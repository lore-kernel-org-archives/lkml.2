Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2EMOYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:24:41 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48813 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2EMOYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:24:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 13 May 2012 23:24:38 +0900
In-Reply-To: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 13 May 2012 07:03:59 -0400")
Message-ID: <87havkduqh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> [   58.052000] FAT-fs (sda1): Directory bread(block 396820) failed
> [   58.060000] FAT-fs (sda1): Directory bread(block 396821) failed
> ....
> ...
> .
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>

Looks fine.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

> ---
>  fs/fat/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index aca191b..b2cdbf4 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -98,8 +98,8 @@ next:
>  
>  	*bh = sb_bread(sb, phys);
>  	if (*bh == NULL) {
> -		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
> -		       (llu)phys);
> +		fat_msg_ratelimit(sb, KERN_ERR, "Directory bread(block %llu) "
> +				"failed", (llu)phys);
>  		/* skip this block */
>  		*pos = (iblock + 1) << sb->s_blocksize_bits;
>  		goto next;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
