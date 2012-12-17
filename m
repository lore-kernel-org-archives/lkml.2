Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2LQVkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:40:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36130 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2LQVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:40:38 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Dongjin Kim <tobetter@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ODROID-X: dts: Add mshc node for ODROID-X board
Date: Mon, 17 Dec 2012 22:40:35 +0100
Message-ID: <2216925.ElgEB0zitR@flatron>
User-Agent: KMail/4.9.4 (Linux/3.7.0-gentoo; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1355774107-364-5-git-send-email-tobetter@gmail.com>
References: <1355774107-364-1-git-send-email-tobetter@gmail.com> <1355774107-364-5-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongjin,

On Tuesday 18 of December 2012 04:55:07 Dongjin Kim wrote:
> Adding the device node to support eMMC storage on SDCARD4 ports,
> controlled by Mobile Storage Host Controller.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts index 3943011..fbd0b51
> 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidx.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -73,4 +73,25 @@
>  			linux,default-trigger = "mmc0";
>  		};
>  	};
> +
> +	mshc@12550000 {
> +		num-slots = <1>;
> +		supports-highspeed;
> +		broken-cd;
> +		fifo-depth = <0x80>;
> +		card-detect-delay = <200>;
> +		samsung,dw-mshc-ciu-div = <3>;
> +		samsung,dw-mshc-sdr-timing = <2 3 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2 3>;
> +
> +		slot@0 {
> +			reg = <0>;
> +			bus-width = <8>;
> +			gpios = <&gpk0 0 3>, <&gpk0 1 3>,
> +				<&gpk0 3 3>, <&gpk0 4 3>,
> +				<&gpk0 5 3>, <&gpk0 6 3>,
> +				<&gpk1 3 4>, <&gpk1 4 4>,
> +				<&gpk1 5 4>, <&gpk1 6 4>;

What is the gpios property for in this node? Pin configuration using 
legacy GPIO bindings is not supported anymore on Exynos4. Pin control 
bindings must be used.

Best regards,
Tomasz Figa

