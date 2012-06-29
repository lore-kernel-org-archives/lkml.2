Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2F2STh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:19:37 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:42416 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2F2STg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:19:36 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=zlDH1YBpq6KBIae1ne901af4gryvYachRwb7DRp3ZT0p7gUAGyP0OcEzp+89
	pr6FIXpFC/zCl4XhIab2YSA8YE5ZGGjv9sW8OIznWhAgjsPNkXOqxceU0
	+9jTUy5CFYmClpziIlv3gptIKKiN6N46mKj8WpDHJM3txY4UvDcbEk=;
X-Spam-Processed: mail.digidescorp.com, Fri, 29 Jun 2012 13:19:35 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=152756e0c6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1340993974.9826.4.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Fix non-atomic NFS i_pos read
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 13:19:34 -0500
In-Reply-To: <877guqt2kf.fsf@devron.myhome.or.jp>
References: <1340990350-9565-1-git-send-email-steve@digidescorp.com>
	 <877guqt2kf.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 03:06 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > fat_encode_fh() can fetch an invalid i_pos value on systems
> > where 64-bit accesses are not atomic. Make it use the same
> > accessor as the rest of the FAT code.
> >
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> > ---
> > diff -uprN linux-3.5-rc4/fs/fat/inode.c new/fs/fat/inode.c
> > --- linux-3.5-rc4/fs/fat/inode.c	2012-06-29 11:20:12.781348652 -0500
> > +++ new/fs/fat/inode.c	2012-06-29 11:25:29.484713183 -0500
> > @@ -738,22 +738,22 @@ static int
> >  fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
> >  {
> >  	int len = *lenp;
> > -	u32 ipos_h, ipos_m, ipos_l;
> > +	struct super_block *sb = inode->i_sb;
> > +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> 
> sb seems to be unused. So, we can just
> 
> 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
> 
> true? Otherwise, ack.
OK, I'll repost with that change.

> 
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> Just curious, this happened on the real system? I recently heard about
> NFS issue.
Not that I'm aware of. Can you point me to any discussion of the NFS
issue? I've spent a lot of time recently studying the FAT NFS
implementation and come to the conclusion that it is extremely
vulnerable to inode eviction.  More to follow...

Regards,
Steve


