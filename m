Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1KGQXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:23:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16703 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab1KGQXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:23:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Nov 2011 08:23:31 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
CC: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 7 Nov 2011 08:23:29 -0800
Subject: RE: [PATCH] pinctrl: hide subsystem from the populace
Thread-Topic: [PATCH] pinctrl: hide subsystem from the populace
Thread-Index: AcydXAudSBusucF9SRmJN6OiVFlTrAADR1bg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A5023@HQMAIL01.nvidia.com>
References: <1320675304-1857-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1320675304-1857-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, November 07, 2011 7:15 AM:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Machines that have embedded pin controllers need to select them
> explicitly, so why broadcast their config options to menuconfig.
> We provide a helpful submenu for those machines that do select
> it, making it possible to enable debugging for example.
...
> -menuconfig PINCTRL
> -	bool "PINCTRL Support"
> +config PINCTRL
> +	bool
>  	depends on EXPERIMENTAL
> -	help
> -	  This enables the PINCTRL subsystem for controlling pins
> -	  on chip packages, for example multiplexing pins on primarily
> -	  PGA and BGA packages for systems on chip.
> -
> -	  If unsure, say N.

This seems OK.

>  if PINCTRL
> 
> +menu "Pin controllers"
> +	depends on PINCTRL
> +
>  config PINMUX
>  	bool "Support pinmux controllers"
>  	help

But shouldn't PINMUX and PINMUX_${soc} also have their help text removed;
it seems like if a SoC selects PINCTRL, it would also select PINMUX if
appropriate, and the relevant PINMUX_${soc} too?

I assume there are also patches for arch/arm/mach-${foo}/Kconfig somewhere
to select PINCTRL when appropriate; they didn't show up in my inbox, but
I haven't checked my sub-folders yet, so perhaps they're already there.

-- 
nvpublic

