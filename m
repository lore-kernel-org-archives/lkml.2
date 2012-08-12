Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2HLEFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:05:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55797 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2HLEFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:05:12 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] fat: use accessor function for msdos_dir_entry 'start'
References: <1344743810-2443-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 12 Aug 2012 13:05:07 +0900
In-Reply-To: <1344743810-2443-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 11 Aug 2012 23:56:50 -0400")
Message-ID: <871ujclpqk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Use accessor function for msdos_dir_entry 'start'

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Looks good. Thanks.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/dir.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 7b1b9c1..2f3e66e 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1143,10 +1143,8 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec *ts)
>  		de[0].ctime_cs = de[1].ctime_cs = 0;
>  		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = 0;
>  	}
> -	de[0].start = cpu_to_le16(cluster);
> -	de[0].starthi = cpu_to_le16(cluster >> 16);
> -	de[1].start = cpu_to_le16(MSDOS_I(dir)->i_logstart);
> -	de[1].starthi = cpu_to_le16(MSDOS_I(dir)->i_logstart >> 16);
> +	fat_set_start(&de[0], cluster);
> +	fat_set_start(&de[1], MSDOS_I(dir)->i_logstart);
>  	de[0].size = de[1].size = 0;
>  	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
>  	set_buffer_uptodate(bhs[0]);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
