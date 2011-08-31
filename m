Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HaCGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:06:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42479 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1HaCGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110830153944.GF16202@quack.suse.cz>
References: <CAFNq8R7dt03bXJUe4gVcZOGRSqJ7uPJHTFeXoaGTu2pKuNBCfw@mail.gmail.com>
	<20110830153944.GF16202@quack.suse.cz>
Date: Wed, 31 Aug 2011 10:06:31 +0800
Message-ID: <CAFNq8R5GqbAcFmc+EgbFO63BCrvQQ4WCB+_LhPRJ=vR9g4CdGw@mail.gmail.com>
Subject: Re: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
From: Li Haifeng <omycle@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Jan.

2011/8/30 Jan Kara <jack@suse.cz>:
> On Tue 30-08-11 20:11:28, Li Haifeng wrote:
>> I am sorry, the last patch "fix the outdated comment in
>> ext2_nfs_get_inode()" has some " whitespace errors detected". So
>> correct it and remake it.
>>
>> I will be more careful later.
>  Hmm, your patch still has mangled whitespaces and wrapped long lines.
> Please make sure your mailer doesn't do it or use git send-email to send
> patches. Also the subject line misses "ext2:" in the beginning (after
> [PATCH]). Finally, I've further changed the text in the comment because
> "And" does not really make sense in that context to me. The patch I now
> carry in my tree is below.
>
>                                                                Honza
>
> From 8e871fa6a2db8ec615614e547d95de21f9045a52 Mon Sep 17 00:00:00 2001
> From: Li Haifeng <omycle@gmail.com>
> Date: Tue, 30 Aug 2011 17:32:50 +0200
> Subject: [PATCH] ext2: fix the outdated comment in ext2_nfs_get_inode()
>
> Signed-off-by: Li Haifeng <omycle@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext2/super.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 174782f..adf3cde 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -327,10 +327,10 @@ static struct inode *ext2_nfs_get_inode(struct super_block *sb,
>        if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
>                return ERR_PTR(-ESTALE);
>
> -       /* iget isn't really right if the inode is currently unallocated!!
> -        * ext2_read_inode currently does appropriate checks, but
> -        * it might be "neater" to call ext2_get_inode first and check
> -        * if the inode is valid.....
> +       /*
> +        * ext2_iget isn't quite right if the inode is currently unallocated!
> +        * However ext2_iget currently does appropriate checks to handle stale
> +        * inodes so everything is OK.
>         */
>        inode = ext2_iget(sb, ino);
>        if (IS_ERR(inode))
> --
> 1.7.1
>



-- 
Li Haifeng
Laboratory of Service Computing Technology and System
Home page:http://tek-life.org
