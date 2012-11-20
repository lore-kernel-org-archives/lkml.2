Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2KTQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:08:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42244 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2KTQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:08:50 -0500
Date: Tue, 20 Nov 2012 16:08:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Move board specific GPIO info out to
 subordinate DTS files
Message-ID: <20121120160846.GC28265@gmail.com>
References: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
 <1352985288-29518-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352985288-29518-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Lee Jones wrote:

> GPIO numbers for the newly created gpio-regulator will differ from
> board to board. Therefore it's not sensible to leave this information
> in the top level DTSI file. Let's move them out to the DTS files
> where they can correctly vary.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/dbx5x0.dtsi    |    2 --
>  arch/arm/boot/dts/hrefprev60.dts |    7 +++++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> index d8ba489..9f55363 100644
> --- a/arch/arm/boot/dts/dbx5x0.dtsi
> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> @@ -638,8 +638,6 @@
>  			regulator-name = "mmci-reg";
>  			regulator-type = "voltage";
>  
> -			gpios = <&tc3589x_gpio 18 0x4>;
> -			gpio-enable = <&tc3589x_gpio 17 0x4>;
>  			states = <1800000 0x1
>  				  2900000 0x0>;
>  
> diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
> index b398946..eec29c4 100644
> --- a/arch/arm/boot/dts/hrefprev60.dts
> +++ b/arch/arm/boot/dts/hrefprev60.dts
> @@ -37,5 +37,12 @@
>  				reset-gpio = <&tc3589x_gpio 13 0x4>;
>  			};
>  		};
> +
> +		vmmci: regulator-gpio {
> +			gpios = <&tc3589x_gpio 18 0x4>;
> +			gpio-enable = <&tc3589x_gpio 17 0x4>;
> +
> +			status = "okay";
> +		};
>  	};
>  };
> -- 
> 1.7.9.5

Prod for Linus.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
