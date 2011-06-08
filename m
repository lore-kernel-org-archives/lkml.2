Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1FHSbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:31:15 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58771 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1FHSbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:31:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] fs/fat: fix build warning
References: <1307550963-26352-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 09 Jun 2011 03:31:08 +0900
In-Reply-To: <1307550963-26352-1-git-send-email-linus.walleij@stericsson.com>
	(Linus Walleij's message of "Wed, 8 Jun 2011 18:36:03 +0200")
Message-ID: <87zklstbtf.fsf@devron.myhome.or.jp>
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

Thanks. I'll apply.

> Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> v2: use uninitialized_var() macro, this is verified to work with
> static code-checking tools.
> ---
>  fs/fat/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 4ad6473..5efbd5d 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1231,7 +1231,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
>  	struct super_block *sb = dir->i_sb;
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
> -	struct msdos_dir_entry *de;
> +	struct msdos_dir_entry *uninitialized_var(de);
>  	int err, free_slots, i, nr_bhs;
>  	loff_t pos, i_pos;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
