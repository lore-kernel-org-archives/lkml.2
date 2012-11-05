Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2KEKxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:53:20 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57544 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2KEKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:53:19 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2 2/3] fat: notify when discard is not supported
References: <1351924119-14284-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 19:53:16 +0900
In-Reply-To: <1351924119-14284-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 3 Nov 2012 15:28:39 +0900")
Message-ID: <87k3u0micj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> FAT also notify warning message about discard support
> as ext4(http://patchwork.ozlabs.org/patch/192668/)

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/inode.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 8d79657..3b48bab 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -26,6 +26,7 @@
>  #include <linux/writeback.h>
>  #include <linux/log2.h>
>  #include <linux/hash.h>
> +#include <linux/blkdev.h>
>  #include <asm/unaligned.h>
>  #include "fat.h"
>  
> @@ -1446,6 +1447,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
>  		goto out_fail;
>  	}
>  
> +	if (sbi->options.discard) {
> +		struct request_queue *q = bdev_get_queue(sb->s_bdev);
> +		if (!blk_queue_discard(q))
> +			fat_msg(sb, KERN_WARNING,
> +					"mounting with \"discard\" option, but "
> +					"the device does not support discard");
> +	}
> +
>  	return 0;
>  
>  out_invalid:

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
