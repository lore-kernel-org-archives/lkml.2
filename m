Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2CCU7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 15:59:31 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:53341 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2CCU7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 15:59:03 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ravishankar N <cyberax82@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] fat: Fix bug in enforcing Long File Name length.
References: <1330737405-7129-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 04 Mar 2012 05:59:00 +0900
In-Reply-To: <1330737405-7129-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Fri, 2 Mar 2012 20:16:45 -0500")
Message-ID: <878vjhv1t7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>  Since '*outlen' is initialized to zero,it is currently possible to create a f ilename of length (FAT_LFN_LEN +1) when utf8 is not enabled.To enforce the FA T_LFN_LEN limit, we must perform one less iteration.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Ravishankar N <cyberax82@gmail.com>
> ---
>  fs/fat/namei_vfat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index aae3b4e..98ae804 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -522,7 +522,7 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>  		op = &outname[*outlen * sizeof(wchar_t)];
>  	} else {
>  		for (i = 0, ip = name, op = outname, *outlen = 0;
> -			 i < len && *outlen <= FAT_LFN_LEN;
> +			 i < len && *outlen < FAT_LFN_LEN;
>  			 *outlen += 1) {
>  			if (escape && (*ip == ':')) {
>  				if (i > len - 5)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
