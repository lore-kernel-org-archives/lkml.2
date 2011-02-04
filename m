Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1BDTfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:35:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BDTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:35:03 -0500
Date: Fri, 4 Feb 2011 20:34:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Simon Horman <horms@verge.net.au>
cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Molton <ian@mnementh.co.uk>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] tmio_mmc: Improve readability of the output of
 pr_debug_status()
In-Reply-To: <1296808387-21935-1-git-send-email-horms@verge.net.au>
Message-ID: <Pine.LNX.4.64.1102042028120.14717@axis700.grange>
References: <1296808387-21935-1-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:misrM/rNOc7okR5aHMNIbs24AsIkRBQ+ouc39uv8of/
 heASwZ/YReSdn/9/zRPl+isKvi06YtVweDtCiG9Kieb6IIcbcd
 CBoQ1d+ifw/AyxFEpIqdzFqSLiV25vt9aAvIKlV4MZKJsYnSPL
 XlERSS48jcfmG1JBJTBwR28O0tZZ5pNLeA80ekggIPGPCPRVTB
 8sOe6k4QREX90B2/s+32ImMFxsgBixi4l7+aFzmodA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Simon Horman wrote:

> Signed-off-by: Simon Horman <horms@verge.net.au>
> ---
>  drivers/mmc/host/tmio_mmc.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
> index 6f724de..811427d 100644
> --- a/drivers/mmc/host/tmio_mmc.h
> +++ b/drivers/mmc/host/tmio_mmc.h
> @@ -237,12 +237,16 @@ static inline void tmio_mmc_kunmap_atomic(void *virt,
>  
>  #define STATUS_TO_TEXT(a) \
>  	do { \
> -		if (status & TMIO_STAT_##a) \
> +		if (status & TMIO_STAT_##a) { \
> +			if (i++) \
> +				printk("|"); \
>  			printk(#a); \
> +		} \

Personally, I find it a bad idea to use variables in macros without 
explicitly passing them in the parameter list. Yes, this macro is already 
using "status" in that way, still, I don't think, that adding more such 
variables is good. Why not make it STATUS_TO_TEXT(a, status, i) and also 
add spaces for better yet readability like printk(" | ")?

Thanks
Guennadi

>  	} while (0)
>  
>  void pr_debug_status(u32 status)
>  {
> +	int i = 0;
>  	printk(KERN_DEBUG "status: %08x = ", status);
>  	STATUS_TO_TEXT(CARD_REMOVE);
>  	STATUS_TO_TEXT(CARD_INSERT);
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
