Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1AXVYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:24:07 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:55615 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab1AXVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:24:05 -0500
From: Kevin Hilman <khilman@ti.com>
To: Julia Lawall <julia@diku.dk>
Cc: Tony Lindgren <tony@atomide.com>, kernel-janitors@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] arch/arm/mach-omap2/smartreflex.c: Add missing IS_ERR test
Organization: Texas Instruments, Inc.
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
	<1295898922-18822-5-git-send-email-julia@diku.dk>
Date: Mon, 24 Jan 2011 13:24:00 -0800
In-Reply-To: <1295898922-18822-5-git-send-email-julia@diku.dk> (Julia Lawall's
	message of "Mon, 24 Jan 2011 20:55:22 +0100")
Message-ID: <87tygy807j.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> Function _sr_lookup, defined in the same file, returns ERR_PTR not NULL in
> an error case.

Thanks, will queue this via the OMAP tree for 2.6.38-rc.

Kevin

> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> identifier f;
> @@
> f(...) { ... return ERR_PTR(...); }
>
> @@
> identifier r.f, fld;
> expression x;
> statement S1,S2;
> @@
>  x = f(...)
>  ... when != IS_ERR(x)
> (
>  if (IS_ERR(x) ||...) S1 else S2
> |
> *x->fld
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  arch/arm/mach-omap2/smartreflex.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index 77ecebf..d7deadf 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -966,7 +966,7 @@ static int __devexit omap_sr_remove(struct platform_device *pdev)
>  	}
>  
>  	sr_info = _sr_lookup(pdata->voltdm);
> -	if (!sr_info) {
> +	if (IS_ERR(sr_info)) {
>  		dev_warn(&pdev->dev, "%s: omap_sr struct not found\n",
>  			__func__);
>  		return -EINVAL;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
