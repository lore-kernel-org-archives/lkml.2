Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KPOAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:00:36 -0500
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:60032 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752023Ab2KPOAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:00:33 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2012 09:00:33 EST
Date: Fri, 16 Nov 2012 14:50:43 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 00/11] watchdog/at91sam9_wdt: use watchdog framework,
 support DT
Message-ID: <20121116135043.GI4398@game.jcrosoft.org>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4983795938505698181
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:15 Wed 14 Nov     , Wenyou Yang wrote:
> Hi, All
> 
> The patch series is intended to convert to use the watchdog framework,
> and add support to device tree.
> It has been tested on sam9m10g45ek, sam9g20ek, sam9263ek and sam9g25ek.
you need to check Fabio wrok which is present on the ML for a while and  was
reviewed and binding too

Best Regards,
J.
> 
> It is based on v3.7-rc5.
> 
> Best Regards
> Wenyou Yang
> 
> Wenyou Yang (11):
>   watchdog/at91sam9_wdt: remove the file_operations struct
>   watchdog/at91sam9_wdt: change the at91wdt_private struct to the
>     at91wdt_drvdata struct
>   watchdog/at91sam9_wdt: change the wdt_read and wdt_write macro to the
>     inline function
>   watchdog/at91sam9_wdt: change "at91_wdt_settimeout" function name to
>     "at91wdt_enable"
>   watchdog/at91sam9_wdt: add to use the watchdog framework
>   watchdog/at91sam9_wdt: change the timer function name
>   watchdog/at91sam9_wdt: add nowayout helpers to Watchdog Timer Driver
>     Kernel API
>   watchdog/at91sam9_wdt: use module_platform_driver()
>   watchdog/at91sam9_wdt: add support to device tree
>   watchdog/at91sam9_wdt: using dev_info replaces pr_info, dev_crit
>     repalces pr_crit
>   ARM: dts: add the watchdog nodes for atmel SoC
> 
>  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   14 +
>  arch/arm/boot/dts/at91sam9260.dtsi                 |    6 +
>  arch/arm/boot/dts/at91sam9263.dtsi                 |    6 +
>  arch/arm/boot/dts/at91sam9263ek.dts                |    4 +
>  arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |    4 +
>  arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +
>  arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
>  arch/arm/boot/dts/at91sam9m10g45ek.dts             |    4 +
>  arch/arm/boot/dts/at91sam9n12.dtsi                 |    6 +
>  arch/arm/boot/dts/at91sam9n12ek.dts                |    4 +
>  arch/arm/boot/dts/at91sam9x5.dtsi                  |    6 +
>  drivers/watchdog/Kconfig                           |    1 +
>  drivers/watchdog/at91sam9_wdt.c                    |  294 ++++++++------------
>  13 files changed, 185 insertions(+), 173 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> 
> -- 
> 1.7.9.5
> 
