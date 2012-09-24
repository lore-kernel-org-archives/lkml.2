Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2IXCpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:45:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37214 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab2IXCp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:45:27 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
 arm/common
Thread-Topic: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
 arm/common
Thread-Index: AQHNlz5P7Id64n7/pEWRn/L8Ro/of5eYzgEA
Date: Mon, 24 Sep 2012 02:44:35 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA8D0DF@DBDE01.ent.ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-2-git-send-email-mporter@ti.com>
In-Reply-To: <1348152226-13588-2-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 20:13:34, Porter, Matt wrote:
> Move mach-davinci/dma.c to common/edma.c so it can be used
> by OMAP (specifically AM33xx atm) as well. This just moves
> the private EDMA API but does not support OMAP.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/Kconfig                           |    1 +
>  arch/arm/common/Kconfig                    |    3 +
>  arch/arm/common/Makefile                   |    1 +
>  arch/arm/common/edma.c                     | 1588 ++++++++++++++++++++++++++++
>  arch/arm/include/asm/mach/edma.h           |  267 +++++
>  arch/arm/mach-davinci/Makefile             |    2 +-
>  arch/arm/mach-davinci/devices.c            |    3 +-
>  arch/arm/mach-davinci/dm355.c              |    2 +-
>  arch/arm/mach-davinci/dm365.c              |    2 +-
>  arch/arm/mach-davinci/dm644x.c             |    2 +-
>  arch/arm/mach-davinci/dm646x.c             |    2 +-
>  arch/arm/mach-davinci/dma.c                | 1588 ----------------------------


>  arch/arm/mach-davinci/include/mach/asp.h   |    2 +-

This will clash with patch "ASoC/ARM: Davinci: McASP: split asp header
into platform and audio specific" queued in ASoC tree by Mark Brown 
tree (Auio - ASoC Tree)

I forgot to mention this last time.  Sorry

>  arch/arm/mach-davinci/include/mach/da8xx.h |    3 +-
>  arch/arm/mach-davinci/include/mach/edma.h  |  267 -----
>  arch/arm/mach-davinci/include/mach/spi.h   |    2 +-
>  arch/arm/plat-omap/Kconfig                 |    1 +
>  17 files changed, 1872 insertions(+), 1864 deletions(-)
>  create mode 100644 arch/arm/common/edma.c
>  create mode 100644 arch/arm/include/asm/mach/edma.h
>  delete mode 100644 arch/arm/mach-davinci/dma.c
>  delete mode 100644 arch/arm/mach-davinci/include/mach/edma.h
> 
...snip...
...snip...


Regards, 
Gururaja
