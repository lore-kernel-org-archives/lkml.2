Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2JJTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:16:59 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:50460 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753731Ab2JJTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:16:58 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2012 15:16:58 EDT
Date: Wed, 10 Oct 2012 21:04:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 5/6] ARM: ux500: Enable SDI4 port on the u9540 when
 booting with Device Tree
Message-ID: <20121010190437.GU12801@game.jcrosoft.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349882335-6786-6-git-send-email-lee.jones@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14362260686850468863
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:18 Wed 10 Oct     , Lee Jones wrote:
> Here we add the device node for the SDI4 (MMC) port to the u9540
> Device Tree source file. This will allow successful probing of
> the internal MMC storage device when booting with DT enabled.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/u9540.dts |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/u9540.dts b/arch/arm/boot/dts/u9540.dts
> index 28efe20..2dade76 100644
> --- a/arch/arm/boot/dts/u9540.dts
> +++ b/arch/arm/boot/dts/u9540.dts
> @@ -21,7 +21,6 @@
>  	};
>  
>  	soc-u9500 {
> -
why?
>  		uart@80120000 {
>  			status = "okay";
>  		};
> @@ -33,5 +32,16 @@
>  		uart@80007000 {
>  			status = "okay";
>  		};
> +
> +		// On-board eMMC
no c++ comment
> +		sdi4_per2@80114000 {
> +			arm,primecell-periphid = <0x10480180>;
> +		        max-frequency = <50000000>;
> +			bus-width = <8>;
> +			mmc-cap-mmc-highspeed;
> +			vmmc-supply = <&ab8500_ldo_aux2_reg>;
you need add the pinctrl here

Best Regards,
J.
