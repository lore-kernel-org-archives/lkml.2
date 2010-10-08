Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab0JHXzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 19:55:31 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9525 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab0JHXza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 19:55:30 -0400
X-RZG-AUTH: :IGUKb2CkcrLHmZv+FHarxbxlXmJO7WRQLa+vsyW+4RLunWeioNr6KNslwIQ=
X-RZG-CLASS-ID: mo00
From: Stephan Linz <linz@li-pro.net>
Organization: Li-Pro.Net
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and Torpedo
Date: Sat, 9 Oct 2010 01:55:25 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.28-19-generic; KDE/4.2.4; x86_64; ; )
Cc: Tim Nordell <tim.nordell@logicpd.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com> <20100928171908.GE3117@atomide.com>
In-Reply-To: <20100928171908.GE3117@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010090155.25932.linz@li-pro.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
Hi Tim,

nice to see my patches here on the Linux mailinglists. I have not been working 
on it for a long time. Tim, how we can work together? Are you working for 
LogicPD?


Bye,
Stephan

Am Dienstag, 28. September 2010, um 19:19:09 schrieb Tony Lindgren:
> * Tim Nordell <tim.nordell@logicpd.com> [100927 08:57]:
> > This was tested (and based) against 2.6.36-rc5
> >
> > Difference from patch v3 1/4:
> >  - Merged DEBUG_LL support patch (patch v3 5/5) into first patch
> >  - Added "select OMAP_PACKAGE_CBB" into Kconfig for both boards
> >
> > Tim Nordell (4):
> >   Adding LogicPD OMAP3 board support
> >   ARM: OMAP3LOGIC: Adding SDMMC support
> >   ARM: OMAP3: Add generic smsc911x support when connected to GPMC
> >   ARM: OMAP3LOGIC: Added SMSC Ethernet board support
> >
> >  arch/arm/mach-omap2/Kconfig                     |   20 ++
> >  arch/arm/mach-omap2/Makefile                    |    7 +
> >  arch/arm/mach-omap2/board-omap3logic.c          |  244
> > +++++++++++++++++++++++ arch/arm/mach-omap2/gpmc-smsc911x.c             |
> >  113 +++++++++++ arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |   35
> > ++++
> >  arch/arm/plat-omap/include/plat/uncompress.h    |    2 +
> >  6 files changed, 421 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-omap2/board-omap3logic.c
> >  create mode 100644 arch/arm/mach-omap2/gpmc-smsc911x.c
> >  create mode 100644 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h
>
> Thanks, queuing all of them for the upcoming merge window.
> I've updated the MMC related patch with the following to
> keep it compiling with the MMC related platform init changes.
>
> Regards,
>
> Tony
>
> --- a/arch/arm/mach-omap2/board-omap3logic.c
> +++ b/arch/arm/mach-omap2/board-omap3logic.c
> @@ -26,6 +26,7 @@
>  #include <linux/regulator/machine.h>
>
>  #include <linux/i2c/twl.h>
> +#include <linux/mmc/host.h>
>
>  #include <mach/hardware.h>
>  #include <asm/mach-types.h>
> @@ -112,7 +113,7 @@ static struct omap2_hsmmc_info __initdata
> board_mmc_info[] = { {
>  		.name		= "external",
>  		.mmc		= 1,
> -		.wires		= 4,
> +		.caps		= MMC_CAP_4_BIT_DATA,
>  		.gpio_cd	= -EINVAL,
>  		.gpio_wp	= -EINVAL,
>  	},
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Viele Grüße,
Stephan Linz
______________________________________________________________________________
OpenDCC: http://www.li-pro.net/opendcc.phtml
PC/M: http://www.li-pro.net/pcm.phtml
CDK4AVR: http://cdk4avr.sourceforge.net/
CDK4NIOS: http://cdk4nios.sourceforge.net/
CDK4MSP: http://cdk4msp.sourceforge.net/
CPM4L: http://download.opensuse.org/repositories/home:/rexut:/CPM4L
