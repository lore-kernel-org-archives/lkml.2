Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2FVTrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:47:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38639 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2FVTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:47:09 -0400
Message-ID: <4FE4CBB8.1010800@landley.net>
Date: Fri, 22 Jun 2012 14:47:04 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "G.Shark Jeong" <gshark.jeong@gmail.com>
CC: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        milo kim <milo.kim@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/1 v4] leds: Add LED driver for lm3556 chip
References: <1340323926-6826-1-git-send-email-gshark.jeong@gmail.com> <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 07:12 PM, G.Shark Jeong wrote:
> From: "G.Shark Jeong" <gshark.jeong@gmail.com>
> 
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf
> 
> Tested on OMAP4430
...
> +Indicator pattern example:
> +pattern 0: #echo 0 > sys/class/leds/indicator/pattern
> +....
> +pattern 3: #echo 3 > sys/class/leds/indicator/pattern
> +
> +Indicater brightness can be controlled through

Indicator

> +sys/class/leds/indicator/brightness file.
> +
> +Example:
> +OFF      : #echo 0 > sys/class/leds/indicator/brightness
> +5.86 mA  : #echo 1 > sys/class/leds/indicator/brightness
> +........
> +46.875mA : #echo 8 > sys/class/leds/indicator/brightness
> +
> +Notes
> +-----
> +Driver expects it is registered using the i2c_board_info mechanism.
> +Toregister the chip at address 0x63 on specific adapter, set the platform data

To register

> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -415,6 +415,14 @@ config LEDS_MAX8997
>  	  This option enables support for on-chip LED drivers on
>  	  MAXIM MAX8997 PMIC.
>  
> +config LEDS_LM3556
> +	tristate "LED support for LM3556 Chip"
> +	depends on LEDS_CLASS && I2C
> +	select REGMAP_I2C
> +	help
> +	  This option enables support for LEDs connected LM3556.

connected to

Other than that, documentation bits Acked-by me.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
