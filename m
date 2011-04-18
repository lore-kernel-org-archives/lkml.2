Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1DRQBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:01:45 -0400
Received: from usrtrel01.sonyericsson.com ([65.202.203.201]:8392 "EHLO
	usrtrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1DRQBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:01:38 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 12:01:38 EDT
From: =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonyericsson.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "tony@atomide.com" <tony@atomide.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Apr 2011 17:51:29 +0200
Subject: RE: [PATCH] arm: omap2: enable smc instruction for sleep34xx
Thread-Topic: [PATCH] arm: omap2: enable smc instruction for sleep34xx
Thread-Index: Acvvrqmda2+NUh+vRJOoZIo/Zo/jaQOMGKpw
Message-ID: <00D61D20F3A8774CBC77798B3FBC427082058F986D@seldmbx02.corpusers.net>
References: <1301581164-26538-1-git-send-email-oskar.andero@sonyericsson.com>
In-Reply-To: <1301581164-26538-1-git-send-email-oskar.andero@sonyericsson.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(+ some extra CC's)

> Subject: [PATCH] arm: omap2: enable smc instruction for sleep34xx
> 
> This fixes broken build when using gcc 4.5.
> 
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> ---
>  arch/arm/mach-omap2/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-
> omap2/Makefile
> index a45cd64..512b152 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -68,7 +68,7 @@ obj-$(CONFIG_OMAP_SMARTREFLEX)          +=
> sr_device.o smartreflex.o
>  obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
> 
>  AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
> -AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a
> +AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-
> a$(plus_sec)
> 
>  ifeq ($(CONFIG_PM_VERBOSE),y)
>  CFLAGS_pm_bus.o				+= -DDEBUG
> --
> 1.7.3.4
Ping!

Anyone else that gets bitten by the following when compiling omap2plus_defconfig with gcc 4.5:
arch/arm/mach-omap2/sleep34xx.S:150: Error: selected processor does not support ARM mode `smc #1'

-Oskar
