Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab2EOPLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:11:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49964 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab2EOPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:10:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        joe@perches.com, Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/2] fat: add fat_msg_ratelimit.
References: <1337093162-3963-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 16 May 2012 00:10:54 +0900
In-Reply-To: <1337093162-3963-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Tue, 15 May 2012 10:46:02 -0400")
Message-ID: <87d365o4xt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> I tried to add fat_msg_ratelimit to limit many message at once.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

Please handle those patches, Andrew.

>  fs/fat/fat.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 951d12b..1708d9a 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -335,6 +335,11 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
>  	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
>  __printf(3, 4) __cold
>  void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
> +#define fat_msg_ratelimit(sb, level, fmt, args...)	\
> +	do {	\
> +			if (__ratelimit(&MSDOS_SB(sb)->ratelimit))	\
> +				fat_msg(sb, level, fmt, ## args);	\
> +	 } while (0)
>  extern int fat_clusters_flush(struct super_block *sb);
>  extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
>  extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
