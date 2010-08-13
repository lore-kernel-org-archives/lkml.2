Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396Ab0HMJGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:06:04 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:18144 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761379Ab0HMJGC (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Fri, 13 Aug 2010 05:06:02 -0400
Message-Id: <4C659796020000230001EA4E@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 13 Aug 2010 03:05:58 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <mjg@redhat.com>, <gregkh@suse.de>, <trenn@suse.de>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
        <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Support MSI Poulsbo netbook U110/U115
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

Dennis help me to ported this patch to 2.6.35, and it works as expected.
Could you please give me any suggestions for this patch?


Thank's a lot!
Joey Lee

於 二，2010-07-13 於 15:54 +0800，Lee, Chun-Yi 提到：
> The MSI U110/U115's DSDT have opregion declare, but i915 drm driver
> does not support Poulsbo ship. It causes the acpi backlight control
> interface not generate by i915 drm driver.
> But, we are sure the MSI Poulsbo netbook U110/U115 have workable
> _BCM,_BQC implementation in DSDT and it control brightness by using
> EC but not opregion.
> 
> So, put a dmi detection in msi-laptop driver and also add wlan/bluetooth
> rfkill support on U110/U115.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> ---
>  drivers/platform/x86/msi-laptop.c |   41 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> index afd762b..5f62ad8 100644
> --- a/drivers/platform/x86/msi-laptop.c
> +++ b/drivers/platform/x86/msi-laptop.c
> @@ -60,6 +60,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/rfkill.h>
>  #include <linux/i8042.h>
> +#include <acpi/video.h>
>  
>  #define MSI_DRIVER_VERSION "0.5"
>  
> @@ -524,6 +525,42 @@ static struct dmi_system_id __initdata msi_load_scm_models_dmi_table[] = {
>  		},
>  		.callback = dmi_check_cb
>  	},
> +	{
> +		.ident = "MSI U110",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "U110"),
> +		},
> +		.callback = dmi_check_cb
> +	},
> +	{
> +		.ident = "MSI U115",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "U115"),
> +		},
> +		.callback = dmi_check_cb
> +	},
> +	{ }
> +};
> +
> +static struct dmi_system_id __initdata msi_poulsbo_dmi_table[] = {
> +	{
> +		.ident = "MSI U110",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "U110"),
> +		},
> +		.callback = dmi_check_cb
> +	},
> +	{
> +		.ident = "MSI U115",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "U115"),
> +		},
> +		.callback = dmi_check_cb
> +	},
>  	{ }
>  };
>  
> @@ -801,6 +838,8 @@ static int __init msi_init(void)
>  	if (acpi_video_backlight_support()) {
>  		printk(KERN_INFO "MSI: Brightness ignored, must be controlled "
>  		       "by ACPI video driver\n");
> +		if (dmi_check_system(msi_poulsbo_dmi_table))
> +			acpi_video_register();
>  	} else {
>  		struct backlight_properties props;
>  		memset(&props, 0, sizeof(struct backlight_properties));
> @@ -919,3 +958,5 @@ MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
>  MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
>  MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
>  MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnCR620:*");
> +MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnU110:*");
> +MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnU115:*");

