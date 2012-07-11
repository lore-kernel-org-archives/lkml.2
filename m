Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2GKSoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:44:18 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:25587 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2GKSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:44:16 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=e0CZfCv9QFdwOWtjyORvp31Y3VY8xz1F9vm01YTCrUJ2XWzU7qSob0Vtyz3Q
	ZWpJ0/d6IvCRPs1xU6uq/CZUz+S/7f09cmWSbWDliuX3F2FS16nmq3CyQ
	8lq5hgLitdKSqG+QBsKcet6unJnqICAfYfHM3Qq5spi7FsrXBW3mCw=;
X-Spam-Processed: mail.digidescorp.com, Wed, 11 Jul 2012 13:42:25 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1539320d59=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
Message-ID: <1342032143.2190.22.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH v3 00/17] vfs: add the ability to retry on ESTALE to
 several syscalls
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        michael.brantley@deshaw.com, hch@infradead.org, miklos@szeredi.hu,
        pstaubach@exagrid.com
Date: Wed, 11 Jul 2012 13:42:23 -0500
In-Reply-To: <1340996280-27123-1-git-send-email-jlayton@redhat.com>
References: <1340996280-27123-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff -

On Fri, 2012-06-29 at 14:57 -0400, Jeff Layton wrote: 
> This patchset is the third version of the patchset to add ESTALE
> handling to several syscalls. The basic idea is to allow the client to
> gracefully retry the lookup and call when a NFS server returns ESTALE.

I exercised this using 3.5-rc5 against a memory-starved server that
exports a FAT-backed filesystem. Where normally I see lots of ESTALE
errors due to inode eviction, with this patchset I see none. And, the
performance is much better than the only other way I know to eliminate
the errors, which is to mount with 'lookupcache=none'.

It's not an exhaustive test by any means, just a data point for you. 
Thanks!

Lightly-tested-by: Steve Magnani <steve@digidescorp.com>
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


