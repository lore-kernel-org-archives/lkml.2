Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab1KCRiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1KCRiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:38:54 -0400
Date: Thu, 3 Nov 2011 13:40:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Message-ID: <20111103134056.178ee9e3@barsoom.rdu.redhat.com>
In-Reply-To: <81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 15:42:13 +0000
Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> Hi,
> 
> I should add that we are using iocharset=utf8 mount option which means that the dcache hash/compare functions done in the cifs module do not work because it uses nls_tolower() and nls_strnicmp() both of which for utf8 NLS in the kernel do not do anything at all and effectively behave case sensitively!
> 
> Thus this bug/problem in all likelyhood only affects utf8 iocharset users on a case-insensitive but case-preserving CIFS server that does not support server inode numbers.
> 
> That probably explains why it has not been noticed before!
> 
> We need utf8 thus we still need to fix this issue.
> 
> Best regards,
> 
> 	Anton
> 

I'm confused...

If the filesystem being served out by the server is using utf8, then
how is it handling the case-insensitivity?

-- 
Jeff Layton <jlayton@redhat.com>
