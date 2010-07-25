Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0GYWi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:38:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:8809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0GYWiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:38:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,259,1278313200"; 
   d="scan'208";a="821476443"
Date: Mon, 26 Jul 2010 00:38:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add WM8321 support
Message-ID: <20100725223825.GF2613@sortiz-mobl>
References: <1279718617-13453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279718617-13453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jul 21, 2010 at 02:23:37PM +0100, Mark Brown wrote:
> The WM8321 is a PMIC for low power, high performance applications. From a
> software point of view the device is identical to the WM8320, all the
> differences between the two devices are visible only in hardware.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-core.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
> index 1a968f3..cb94e7e 100644
> --- a/drivers/mfd/wm831x-core.c
> +++ b/drivers/mfd/wm831x-core.c
> @@ -95,6 +95,7 @@ enum wm831x_parent {
>  	WM8311 = 0x8311,
>  	WM8312 = 0x8312,
>  	WM8320 = 0x8320,
> +	WM8321 = 0x8321,
>  };
>  
>  static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
> @@ -1533,6 +1534,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
>  		dev_info(wm831x->dev, "WM8320 revision %c\n", 'A' + rev);
>  		break;
>  
> +	case WM8321:
> +		parent = WM8321;
> +		wm831x->num_gpio = 12;
> +		dev_info(wm831x->dev, "WM8321 revision %c\n", 'A' + rev);
> +		break;
> +
>  	default:
>  		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
>  		ret = -EINVAL;
> @@ -1607,6 +1614,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
>  				      NULL, 0);
>  		break;
>  
> +	case WM8321:
> +		ret = mfd_add_devices(wm831x->dev, -1,
> +				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
> +				      NULL, 0);
> +		break;
> +
>  	default:
>  		/* If this happens the bus probe function is buggy */
>  		BUG();
> @@ -1779,6 +1792,7 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
>  	{ "wm8311", WM8311 },
>  	{ "wm8312", WM8312 },
>  	{ "wm8320", WM8320 },
> +	{ "wm8321", WM8321 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
