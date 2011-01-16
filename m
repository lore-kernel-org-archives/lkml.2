Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1APXTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:19:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1APXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:19:07 -0500
Date: Sun, 16 Jan 2011 23:19:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Message-ID: <20110116231901.GF22723@ZenIV.linux.org.uk>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
 <20110116141105.59e5b3a2@stein>
 <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
 <20110117000659.57352da7@stein>
 <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 03:11:57PM -0800, Linus Torvalds wrote:
> Why the hell should a OCFS2 user have to know that he needs to enable
> configfs to be able to enable ocfs2?
> 
> The thing is, we should do exactly the reverse of what you say, and
> work towards the goal of "depends on" going away. Right now, the main
> reason to use "depends on" is actually just that our Kconfig solvers
> are stupid, and don't generally handle "select" very well. But that's
> hopefully getting fixed.

How do you eliminate things like "it really depends on having DMA"?
When we configure e.g. s390 or uml kernel, it's not like we could
enable a PCI driver and have architecture magically switch to a
PCI-supporting one, after all...
