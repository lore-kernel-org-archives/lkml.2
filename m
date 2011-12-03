Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1LCGKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 01:10:18 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:40606 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909Ab1LCGKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 01:10:15 -0500
Date: Sat, 3 Dec 2011 06:56:59 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        jamie@jamieiles.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/net: add macb ethernet controller in 9g45 DT
Message-ID: <20111203055659.GL18533@game.jcrosoft.org>
References: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
 <1322848237-23154-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322848237-23154-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13471673860529892204
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeguvghnrdhnvghtne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrtdekucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:50 Fri 02 Dec     , Nicolas Ferre wrote:
> Add the Cadence macb ethernet controller in at91sam9g45 .dtsi and
> enable it in at91sam9m10g45ek board device tree file.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi     |    7 +++++++
>  arch/arm/boot/dts/at91sam9m10g45ek.dts |    6 ++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index e89b1d7..67f94d3 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -101,6 +101,13 @@
>  				atmel,use-dma-tx;
>  				status = "disabled";
>  			};
> +
> +			macb0: ethernet@fffbc000 {
> +				compatible = "cdns,at32ap7000-macb", "cdns,macb";
> +				reg = <0xfffbc000 0x100>;
> +				interrupts = <25 4>;
why?
> +				status = "disabled";
> +			};
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> index 85b34f5..17377a2 100644
> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> @@ -30,6 +30,12 @@
>  			usart1: serial@fff90000 {
>  				status = "okay";
>  			};
> +
> +			macb0: ethernet@fffbc000 {
> +				local-mac-address = [3a 0e 03 04 05 06];
please drop this is not supposed to be in the dts but updated for each board

Best Regards,
J.
