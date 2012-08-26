Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2HZOCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:02:22 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60486 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HZOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:02:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/2] fat : no need to reset EOF in ent_put for FAT32
References: <1345883011-6263-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 26 Aug 2012 23:02:18 +0900
In-Reply-To: <1345883011-6263-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 25 Aug 2012 04:23:31 -0400")
Message-ID: <878vd1wy39.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> #define FAT_ENT_EOF(EOF_FAT32)
>
> there is no need to reset value of 'new' for FAT32 as the values is
> already correct
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/fatent.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
> index 31f08ab..af53815 100644
> --- a/fs/fat/fatent.c
> +++ b/fs/fat/fatent.c
> @@ -186,8 +186,6 @@ static void fat16_ent_put(struct fat_entry *fatent, int new)
>  
>  static void fat32_ent_put(struct fat_entry *fatent, int new)
>  {
> -	if (new == FAT_ENT_EOF)
> -		new = EOF_FAT32;
>  

Please remove this new line too. If it was removed,

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

>  	WARN_ON(new & 0xf0000000);
>  	new |= le32_to_cpu(*fatent->u.ent32_p) & ~0x0fffffff;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
