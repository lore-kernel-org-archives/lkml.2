Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab2KAJJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:09:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57166 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab2KAJJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:09:47 -0400
Subject: Re: [PATCH] MFD: twl-core: Fix chip ID for the twl6030-pwm module
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
In-Reply-To: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com>
References: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Thu, 1 Nov 2012 11:09:41 +0200
Message-ID: <1351760981.8788.20.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Tero Kristo <t-kristo@ti.com>

On Wed, 2012-10-31 at 15:54 +0100, Peter Ujfalusi wrote:
> The correct chip id is 1 since the PWM module is on address 0x49. With the
> current TWL6030_MODULE_ID1 the kernel will crash early since:
> #define TWL6030_MODULE_ID1 0x0E
> and
> static struct twl_client twl_modules[4];
> 
> Down in the stack we try to get the module by:
> struct twl_client	*twl = &twl_modules[chip];
> 
> Which obviously going to do nasty things.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi Samuel,
> 
> Can you push this patch to 3.7?
> Without this if the user enables the twl6030-pwm driver the kernel will not
> going to boot on OMAP4.
> 
> Thank you,
> Peter
> 
>  drivers/mfd/twl-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 2624668..d7577cb 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -672,7 +672,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
>  	}
>  
>  	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
> -		child = add_child(TWL6030_MODULE_ID1, "twl6030-pwm", NULL, 0,
> +		child = add_child(SUB_CHIP_ID1, "twl6030-pwm", NULL, 0,
>  				  false, 0, 0);
>  		if (IS_ERR(child))
>  			return PTR_ERR(child);


