Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161298Ab1FAMIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:08:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61740 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696Ab1FAMIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:08:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MwEWgHSX+XLTQrM+e/wNh
Date: Wed, 1 Jun 2011 05:07:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Message-ID: <20110601120754.GC11352@atomide.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
 <1306927051-8937-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306927051-8937-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [110601 04:14]:
> --- a/arch/arm/mach-omap2/board-3430sdp.c
> +++ b/arch/arm/mach-omap2/board-3430sdp.c
> @@ -463,11 +463,11 @@ static struct regulator_init_data sdp3430_vpll2 = {
>  	.consumer_supplies	= sdp3430_vpll2_supplies,
>  };
>  
> -static struct twl4030_codec_audio_data sdp3430_audio;
> +static struct twl4030_codec_data sdp3430_codec;
>  
> -static struct twl4030_codec_data sdp3430_codec = {
> +static struct twl4030_audio_data sdp3430_audio = {
>  	.audio_mclk = 26000000,
> -	.audio = &sdp3430_audio,
> +	.codec = &sdp3430_codec,
>  };
>  
>  static struct twl4030_platform_data sdp3430_twldata = {
> @@ -480,7 +480,7 @@ static struct twl4030_platform_data sdp3430_twldata = {
>  	.madc		= &sdp3430_madc_data,
>  	.keypad		= &sdp3430_kp_data,
>  	.usb		= &sdp3430_usb_data,
> -	.codec		= &sdp3430_codec,
> +	.audio		= &sdp3430_audio,
>  
>  	.vaux1		= &sdp3430_vaux1,
>  	.vaux2		= &sdp3430_vaux2,
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -337,11 +337,11 @@ static struct twl4030_usb_data devkit8000_usb_data = {
>  	.usb_mode	= T2_USB_MODE_ULPI,
>  };
>  
> -static struct twl4030_codec_audio_data devkit8000_audio_data;
> +static struct twl4030_codec_data devkit8000_codec_data;
>  
> -static struct twl4030_codec_data devkit8000_codec_data = {
> +static struct twl4030_audio_data devkit8000_audio_data = {
>  	.audio_mclk = 26000000,
> -	.audio = &devkit8000_audio_data,
> +	.codec = &devkit8000_codec_data,
>  };
>  
>  static struct twl4030_platform_data devkit8000_twldata = {
> @@ -351,7 +351,7 @@ static struct twl4030_platform_data devkit8000_twldata = {
>  	/* platform_data for children goes here */
>  	.usb		= &devkit8000_usb_data,
>  	.gpio		= &devkit8000_gpio_data,
> -	.codec		= &devkit8000_codec_data,
> +	.audio		= &devkit8000_audio_data,
>  	.vmmc1		= &devkit8000_vmmc1,
>  	.vdac		= &devkit8000_vdac,
>  	.vpll1		= &devkit8000_vpll1,
...

Can you please take a look at creating arch/arm/mach-omap2/i2c-twl.c or
something in common-board-devices.c to get rid of the cut and paste
duplication in every board-*.c file?

Maybe you could have a generic twl_init function that allows overriding
things like keypad with board specific configuration?

Regards,

Tony
