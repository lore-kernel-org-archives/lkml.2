Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2I0Cpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:45:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2I0Cp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:45:29 -0400
Date: Wed, 26 Sep 2012 19:42:33 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 04/57] power: ab8500: bm: movimg back to ab8500 platform
 data managment
Message-ID: <20120927024233.GB8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-5-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-5-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:01AM -0600, mathieu.poirier@linaro.org wrote:
> From: Philippe Langlais <philippe.langlais@linaro.org>

The empty message turned me into suspicious mode, and I took another look
at the patch... :-)

> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/power/ab8500_btemp.c      |    8 ++------
>  drivers/power/ab8500_charger.c    |    9 +++------
>  drivers/power/ab8500_fg.c         |    8 ++------
>  drivers/power/abx500_chargalg.c   |    7 ++++---
>  include/linux/mfd/abx500/ab8500.h |    7 ++++++-
>  5 files changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index 94a3ee8..41a8ce4 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -973,14 +973,9 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>  {
>  	int irq, i, ret = 0;
>  	u8 val;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> +	struct ab8500_platform_data *plat_data;
>  	struct ab8500_btemp *di;
>  
> -	if (!plat_data) {
> -		dev_err(&pdev->dev, "No platform data\n");
> -		return -EINVAL;
> -	}
> -

Why? This basically reverts recent change:

commit ec511672b97383107d87e86921b1f0392bc1d000
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Fri Apr 13 10:16:06 2012 +0200

    ab8500_btemp: Harden platform data check

..and other commits from Linus' series.

The patch description doesn't tell anything why this is no longer needed.

[...]
> --- a/include/linux/mfd/abx500/ab8500.h
> +++ b/include/linux/mfd/abx500/ab8500.h
> @@ -170,7 +170,7 @@ enum ab8500_version {
>  #define AB8500_INT_ID_DET_R2F		99
>  #define AB8500_INT_ID_DET_R3F		100
>  #define AB8500_INT_ID_DET_R4F		101
> -#define AB8500_INT_CHAUTORESTARTAFTSEC  102
> +#define AB8500_INT_CHAUTORESTARTAFTSEC	102

This is surely stray change.

>  #define AB8500_INT_CHSTOPBYSEC		103
>  /* ab8500_irq_regoffset[13] -> IT[Source|Latch|Mask]22 */
>  #define AB8500_INT_USB_CH_TH_PROT_F	104
> @@ -289,6 +289,11 @@ struct ab8500_platform_data {
>  	struct regulator_init_data *regulator;
>  	struct ab8500_gpio_platform_data *gpio;
>  	struct ab8500_codec_platform_data *codec;
> +	struct abx500_bm_data *battery;
> +	struct abx500_charger_platform_data *charger;
> +	struct abx500_btemp_platform_data *btemp;
> +	struct abx500_fg_platform_data *fg;
> +	struct abx500_chargalg_platform_data *chargalg;

These seem like stray changes too. At least I don't see how you the new
members in this patch.

>  };
>  
>  extern int __devinit ab8500_init(struct ab8500 *ab8500,
> -- 
> 1.7.5.4
