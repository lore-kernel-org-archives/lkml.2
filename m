Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2IFQTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:19:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707Ab2IFQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:19:40 -0400
Date: Thu, 6 Sep 2012 09:19:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Tero Kristo <t-kristo@ti.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/14] Input: twl4030-vibra: Support for DT booted
 kernel
Message-ID: <20120906161933.GA18562@core.coreip.homeip.net>
References: <1346933541-21547-1-git-send-email-peter.ujfalusi@ti.com>
 <1346933541-21547-9-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346933541-21547-9-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Sep 06, 2012 at 03:12:15PM +0300, Peter Ujfalusi wrote:
> Add support when the kernel has been booted with DT blob. In this case the
> pdata is NULL, we need to reach up to the core node and check if the codec
> part has been enabled to determine if we need to coexist with the codec or
> not.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/input/misc/twl4030-vibra.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
> index fc0ed9b..15620f8 100644
> --- a/drivers/input/misc/twl4030-vibra.c
> +++ b/drivers/input/misc/twl4030-vibra.c
> @@ -26,6 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/jiffies.h>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
>  #include <linux/workqueue.h>
>  #include <linux/i2c/twl.h>
>  #include <linux/mfd/twl4030-audio.h>
> @@ -194,13 +195,28 @@ static int twl4030_vibra_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
>  			 twl4030_vibra_suspend, twl4030_vibra_resume);
>  
> +static bool twl4030_vibra_check_coexist(struct twl4030_vibra_data *pdata,
> +			      struct device_node *node)
> +{
> +	if (pdata && pdata->coexist)
> +		return true;
> +
> +#ifdef CONFIG_OF
> +	if (of_find_node_by_name(node, "codec"))
> +		return true;
> +#endif

In patch 6 you added a stub for of_find_node_by_name(), so do you really
need this #ifdef?

Otherwise it looks good.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
