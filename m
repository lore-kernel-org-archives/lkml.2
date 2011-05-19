Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab1ESXXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:23:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55505 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab1ESXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:23:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] fs/fat: fix build warning
References: <1305839013-31909-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 20 May 2011 08:23:01 +0900
In-Reply-To: <1305839013-31909-1-git-send-email-linus.walleij@stericsson.com>
	(Linus Walleij's message of "Thu, 19 May 2011 23:03:33 +0200")
Message-ID: <87pqne1dii.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@stericsson.com> writes:

> From: Jonas Aberg <jonas.aberg@stericsson.com>
>
> This fixes a compile warning (unititialized variable) in
> the fat filesystem code.
>
> Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  fs/fat/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index ee42b9e..aace9be 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1229,7 +1229,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
>  	struct super_block *sb = dir->i_sb;
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
> -	struct msdos_dir_entry *de;
> +	struct msdos_dir_entry *de = NULL;
>  	int err, free_slots, i, nr_bhs;
>  	loff_t pos, i_pos;

	struct msdos_dir_entry *uninitialized_var(de);

IIRC, x86 gcc doesn't warn it. Does uninitialized_var(de) make your gcc
version silent? If so, I'd like to change it like this.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
