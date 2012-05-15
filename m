Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab2EOPLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:11:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49969 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065Ab2EOPLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:11:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        joe@perches.com, Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
References: <1337093193-3999-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 16 May 2012 00:11:32 +0900
In-Reply-To: <1337093193-3999-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Tue, 15 May 2012 10:46:33 -0400")
Message-ID: <8762bxo4wr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> When application tried to lookup(opendir/readdir/stat) 5000 files in plugging usb device formatted by FAT, If unplugging usb device while lookup files, so many message occured like the below log. and currently it make app slow.
> So this patch use fat_msg_ratelimit function about this message to decrease this messages.
>
> #> ./file_lookup_testcase ./files_directory/
> [   57.768000] usb 2-1.4: USB disconnect, device number 4

[...]

> [   58.040000] FAT-fs (sda1): Directory bread(block 396818) failed
> [   58.048000] FAT-fs (sda1): Directory bread(block 396819) failed
> [   58.052000] FAT-fs (sda1): Directory bread(block 396820) failed
> [   58.060000] FAT-fs (sda1): Directory bread(block 396821) failed

Thanks.

Please handle those patches, Andrew.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index aca191b..6eaa28c 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -98,8 +98,8 @@ next:
>  
>  	*bh = sb_bread(sb, phys);
>  	if (*bh == NULL) {
> -		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
> -		       (llu)phys);
> +		fat_msg_ratelimit(sb, KERN_ERR,
> +			"Directory bread(block %llu) failed", (llu)phys);
>  		/* skip this block */
>  		*pos = (iblock + 1) << sb->s_blocksize_bits;
>  		goto next;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
