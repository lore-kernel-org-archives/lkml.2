Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838Ab2HLED4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:03:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38893 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2HLEDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1342868717-1712-1-git-send-email-ashish.sangwan2@gmail.com>
References: <1342868717-1712-1-git-send-email-ashish.sangwan2@gmail.com>
Date: Sun, 12 Aug 2012 13:03:54 +0900
Message-ID: <CAKYAXd9ssYNvprrhLHnYFfYg4Be741_gqrH4tmGUNvZntG3RCQ@mail.gmail.com>
Subject: Re: [PATCH] UDF: During mount free lvid_bh before rescanning with
 different blocksize
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <ashish.sangwan2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Jan.

Would you check this patch also ?

Thanks.

2012/7/21, Ashish Sangwan <ashishsangwan2@gmail.com>:
> If s_lvid_bh is not freed and set to NULL before re-scanning partition
> with default block size, we might end up using wrong lvid in case
> s_lvid_bh is not updated in udf_load_logicalvolint during rescan.
>
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>
> ---
>  fs/udf/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index ac8a348..4a95c56 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1961,6 +1961,8 @@ static int udf_fill_super(struct super_block *sb, void
> *options, int silent)
>  			if (!silent)
>  				pr_notice("Rescanning with blocksize %d\n",
>  					  UDF_DEFAULT_BLOCKSIZE);
> +			brelse(sbi->s_lvid_bh);
> +			sbi->s_lvid_bh = NULL;
>  			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
>  			ret = udf_load_vrs(sb, &uopt, silent, &fileset);
>  		}
> --
> 1.7.2.3
>
>
