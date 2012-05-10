Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2EJDac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:30:32 -0400
Received: from hm1831-14.locaweb.com.br ([189.126.112.34]:24885 "EHLO
	hm1831-14.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2EJDaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:30:30 -0400
X-Greylist: delayed 1233 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 23:30:30 EDT
Date: Wed, 9 May 2012 23:58:56 -0300 (BRT)
From: Thiago Rafel Becker <trbecker@trbecker.org>
X-X-Sender: trbecker@nyarly
To: zwu.kernel@gmail.com
cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, wuzhy@linux.vnet.ibm.com,
        stefanha@linux.vnet.ibm.com
Subject: Re: [PATCH] block: remove some unnecessary codes
In-Reply-To: <1336615995-3813-1-git-send-email-zwu.kernel@gmail.com>
Message-ID: <alpine.LNX.2.02.1205092358090.6376@nyarly>
References: <1336615995-3813-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Alpine 2.02 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=dfQ3Kwre c=1 sm=1 a=+R6bPGFZ0javQqA2PyUBzw==:17
	a=hG-0k2JMAeMA:10 a=ES2qV8Hmz3YA:10 a=la6TjtyCKkkA:10 a=kj9zAlcOel0A:10
	a=yrWXaES42gIA:10 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
	a=W0vUJOdyAAAA:8 a=HQQs-36tQIZEBf5W7QQA:9 a=xkXr9Aa0-2PKg8TfhnoA:7
	a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10
	a=zWQKXumA2evbgYzgbGTjVw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should also remove the if statement on line 511.

On Thu, 10 May 2012, zwu.kernel@gmail.com wrote:

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  block/partition-generic.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 6df5d69..4c03880 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -473,7 +473,6 @@ rescan:
>  	/* add partitions */
>  	for (p = 1; p < state->limit; p++) {
>  		sector_t size, from;
> -		struct partition_meta_info *info = NULL;
>
>  		size = state->parts[p].size;
>  		if (!size)
> @@ -509,7 +508,6 @@ rescan:
>  		}
>
>  		if (state->parts[p].has_info)
> -			info = &state->parts[p].info;
>  		part = add_partition(disk, p, from, size,
>  				     state->parts[p].flags,
>  				     &state->parts[p].info);
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
