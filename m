Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2COCzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:55:36 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:26215
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab2COCze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:55:34 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Mar 2012 10:57:09 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120315025707.GA13022@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <4F5F5B3F.2000303@gmail.com>
 <20120314062354.GA8494@shlinux2.ap.freescale.net>
 <4F60979E.3060704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F60979E.3060704@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 09:05:34PM +0800, Rob Herring wrote:
> On 03/14/2012 01:23 AM, Dong Aisheng wrote:
> > On Tue, Mar 13, 2012 at 09:35:43AM -0500, Rob Herring wrote:
> >> On 03/13/2012 03:47 AM, Dong Aisheng wrote:
> >>> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>>
> >>> This patch includes basic dt support which can boot via nfs rootfs.
> >>>
> >>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >>> ---
> >>>  Documentation/devicetree/bindings/arm/fsl.txt |    4 +
> >>>  arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
> >>>  arch/arm/boot/dts/imx28.dtsi                  |   88 +++++++++++++++++++++++++
> >>>  arch/arm/mach-mxs/Kconfig                     |    9 +++
> >>>  arch/arm/mach-mxs/Makefile                    |    1 +
> >>>  arch/arm/mach-mxs/imx28-dt.c                  |   67 +++++++++++++++++++
> >>>  6 files changed, 200 insertions(+), 0 deletions(-)
> > ....
> >>> +				interrupts = <47>;
> >>> +			};
> >>> +		};
> >>> +	};
> >>> +
> >>> +	ahb@80080000 {
> >>> +		compatible = "simple-bus";
> >>> +		#address-cells = <1>;
> >>> +		#size-cells = <1>;
> >>> +		reg = <0x80080000 0x80000>;
> >>> +		ranges;
> >>> +
> >>> +		fec@800f0000 {
> >>> +			compatible = "fsl,imx28-fec";
> >>> +			reg = <0x800f0000 0x4000>;
> >>
> >> This too IIRC.
> >>
> > The size is 16KB/0x4000 in iMX28 spec. :)
> 
> Yes, but the module only uses <4KB. You waste virtual memory space by
> mapping all the unused area. It's not really an issue when you have
> <512MB of RAM, but does become an issue.
> 
Yes, it seems an issue of spec.
And all other places are using the same size.
The simplest way now may be just keep align with spec first.

> >>> +			interrupts = <101>;
> >>> +			status = "disabled";
> >>> +		};
> >>> +
> >>> +		fec@800f4000 {
> >>> +			compatible = "fsl,imx28-fec";
> >>> +			reg = <0x800f4000 0x4000>;
> >>> +			interrupts = <102>;
> >>> +			status = "disabled";
> >>> +		};
> >>> +
> >>> +	};
> >>> +};
> >>> diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
> >>> index c57f996..6ab66af 100644
> >>> --- a/arch/arm/mach-mxs/Kconfig
> >>> +++ b/arch/arm/mach-mxs/Kconfig
> >>> @@ -17,6 +17,15 @@ config SOC_IMX28
> >>>  
> >>>  comment "MXS platforms:"
> >>>  
> >>> +config MACH_IMX28_DT
> >>
> >> Perhaps this should be more generic like MACH_MXS_DT to eventually
> >> support MX23 as well?
> >>
> > I just did like the imx ways.
> > But yes if we see the need when do imx23 dt support.
> > 
> >>> +	bool "Support i.MX28 platforms from device tree"
> >>> +	select SOC_IMX28
> >>> +	select USE_OF
> >>> +	select MACH_MX28EVK
> >>
> >> This should not be selected here.
> >>
> > Like other imx soc dt board files, the imx28-dt.c may need to use some bits
> > like pinmux in mx28evk.c board file.
> > 
> > Yes, currently i can remove it since it is using uboot pinmux setting.
> > But when add other devices support which is not covered in u-boot like flexcan,
> > i may need to use non-dt board's pinmux setting.
> > So maybe we can keep it first and remove it when totally not dependent
> > on non-dt files.
> 
> Okay either way, but my vote would be add it as needed.
> 
Your vote is ok to me.

> >>> + * The code contained herein is licensed under the GNU General Public
> >>> + * License. You may obtain a copy of the GNU General Public License
> >>> + * Version 2 or later at the following locations:
> >>> + *
> >>> + * http://www.opensource.org/licenses/gpl-license.html
> >>> + * http://www.gnu.org/copyleft/gpl.html
> >>> + */
> >>> +
> >>> +#include <linux/init.h>
> >>> +#include <linux/irqdomain.h>
> >>> +#include <linux/of_irq.h>
> >>> +#include <linux/of_platform.h>
> >>> +#include <asm/mach/arch.h>
> >>> +#include <asm/mach/time.h>
> >>> +#include <mach/common.h>
> >>> +#include <mach/mx28.h>
> >>> +
> >>> +static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
> >>> +	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
> >>> +	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
> >>> +	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> >>
> >> Why do you need the old names?
> >>
> > To keep align with the old clocks.
> > See arch/arm/mach-mxs/clock-mx28.c:
> > _REGISTER_CLOCK("imx28-fec.0", NULL, fec_clk)
> > _REGISTER_CLOCK("imx28-fec.1", NULL, fec_clk)
> > Is there any better way to avoid this?
> 
> Yes, you can add more clock look-ups with the DT name.
> 
Got it.

Regards
Dong Aisheng

