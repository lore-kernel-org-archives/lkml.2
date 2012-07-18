Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2GRMXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:23:22 -0400
Received: from antcom.de ([188.40.178.216]:45200 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab2GRMXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:23:20 -0400
Message-ID: <5006AAB3.4040307@antcom.de>
Date: Wed, 18 Jul 2012 14:23:15 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH 4/4] ARM: LPC32xx: Add PWM to base dts file
References: <1342613211-13190-1-git-send-email-stigge@antcom.de> <1342613211-13190-5-git-send-email-stigge@antcom.de>
In-Reply-To: <1342613211-13190-5-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 02:06 PM, Roland Stigge wrote:
> From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---
>  arch/arm/boot/dts/lpc32xx.dtsi |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> --- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
> +++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
> @@ -278,6 +278,17 @@
>  				status = "disabled";
>  			};
>  
> +			pwm1: pwm@0x4005C000 {
> +				compatible = "nxp,lpc3220-pwm";
> +				reg = <0x4005C000 0x4>;
> +				status = "disabled";
> +			};
> +
> +			pwm2: pwm@0x4005C004 {
> +				compatible = "nxp,lpc3220-pwm";
> +				reg = <0x4005C004 0x4>;
> +				status = "disabled";
> +			};
>  		};
>  	};
>  };

Sorry, grabbed old version of patch. Should have been:


			pwm: pwm@4005C000 {
				compatible = "nxp,lpc3220-pwm";
				reg = <0x4005C000 0x8>;
				status = "disabled";
			};

... because the driver now always registers the two channels together.

Will push it this way.

Roland
