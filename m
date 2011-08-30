Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1H3L3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:29:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61127 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1H3L3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110830103545.GA16202@quack.suse.cz>
References: <CAFNq8R62+5dLbDV3b_rtFgMwTZ2abW+h+tg013L=pij60tTRdw@mail.gmail.com>
	<20110830103545.GA16202@quack.suse.cz>
Date: Tue, 30 Aug 2011 19:29:29 +0800
Message-ID: <CAFNq8R7kgizxyZx4EGcno9apv0BDQEN6saz+Nusp5-x5PSz1Mg@mail.gmail.com>
Subject: Re: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
From: Li Haifeng <omycle@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your point. I will remake this patch.

2011/8/30 Jan Kara <jack@suse.cz>
>
> On Tue 30-08-11 17:53:58, Li Haifeng wrote:
> > The function iget  referred by the comment is replaced by ext2_iget .
> > And the ext2_read_inode() is not exist, the ext2_iget is "neater". So
> > the comment is fixed here.
> >
> > Signed-off-by: Li Haifeng <omycle@gmail.com>
> > ---
> >  fs/ext2/super.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index 1dd62ed..994ced3 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -327,10 +327,8 @@ static struct inode *ext2_nfs_get_inode(struct
> > super_block *sb,
> >     if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
> >         return ERR_PTR(-ESTALE);
> >
> > -   /* iget isn't really right if the inode is currently unallocated!!
> > -    * ext2_read_inode currently does appropriate checks, but
> > -    * it might be "neater" to call ext2_get_inode first and check
> > -    * if the inode is valid.....
> > +   /*
> > +    * ext2_iget isn't really right if the inode is currently unallocated!!
>  OK, but we should keep there a note that ext2_iget() does appropriate
> checks to handle stale inodes.
>
>                                                                        Honza
> >      */
> >     inode = ext2_iget(sb, ino);
> >     if (IS_ERR(inode))
> > --
> > 1.7.4.1
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
