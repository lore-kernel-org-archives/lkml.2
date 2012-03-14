Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2CNGvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:51:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36519 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2CNGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:51:34 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Date: Wed, 14 Mar 2012 07:51:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Rob Herring <robherring2@gmail.com>, vinod.koul@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rdunlap@xenotime.net,
        shawn.guo@freescale.com, kernel@pengutronix.de, cjb@laptop.org,
        Dong Aisheng <b29396@freescale.com>, s.hauer@pengutronix.de
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <4F5F5B3F.2000303@gmail.com> <20120314062354.GA8494@shlinux2.ap.freescale.net>
In-Reply-To: <20120314062354.GA8494@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140751.30747.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dong Aisheng,

> On Tue, Mar 13, 2012 at 09:35:43AM -0500, Rob Herring wrote:
> > On 03/13/2012 03:47 AM, Dong Aisheng wrote:
> > > From: Dong Aisheng <dong.aisheng@linaro.org>
> > > 
> > > This patch includes basic dt support which can boot via nfs rootfs.
> > > 
> > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > ---
> > > 
> > >  Documentation/devicetree/bindings/arm/fsl.txt |    4 +
> > >  arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
> > >  arch/arm/boot/dts/imx28.dtsi                  |   88
> > >  +++++++++++++++++++++++++ arch/arm/mach-mxs/Kconfig                  
> > >    |    9 +++
> > >  arch/arm/mach-mxs/Makefile                    |    1 +
> > >  arch/arm/mach-mxs/imx28-dt.c                  |   67
> > >  +++++++++++++++++++ 6 files changed, 200 insertions(+), 0
> > >  deletions(-)
> 
> ....
> 
> > > +				interrupts = <47>;
> > > +			};
> > > +		};
> > > +	};
> > > +
> > > +	ahb@80080000 {
> > > +		compatible = "simple-bus";
> > > +		#address-cells = <1>;
> > > +		#size-cells = <1>;
> > > +		reg = <0x80080000 0x80000>;
> > > +		ranges;
> > > +
> > > +		fec@800f0000 {
> > > +			compatible = "fsl,imx28-fec";
> > > +			reg = <0x800f0000 0x4000>;
> > 
> > This too IIRC.
> 
> The size is 16KB/0x4000 in iMX28 spec. :)

Agreed, the memory map is slightly non-standard.

> 
> > > +			interrupts = <101>;
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +		fec@800f4000 {
> > > +			compatible = "fsl,imx28-fec";
> > > +			reg = <0x800f4000 0x4000>;
> > > +			interrupts = <102>;
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +	};
> > > +};
> > > diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
> > > index c57f996..6ab66af 100644
> > > --- a/arch/arm/mach-mxs/Kconfig
> > > +++ b/arch/arm/mach-mxs/Kconfig
> > > @@ -17,6 +17,15 @@ config SOC_IMX28
> > > 
> > >  comment "MXS platforms:"
> > > 
> > > +config MACH_IMX28_DT
> > 
> > Perhaps this should be more generic like MACH_MXS_DT to eventually
> > support MX23 as well?
> 
> I just did like the imx ways.
> But yes if we see the need when do imx23 dt support.

Let's do it all in one swipe, there's not so much difference between these two 
chips.
> 
> > > +	bool "Support i.MX28 platforms from device tree"
> > > +	select SOC_IMX28
> > > +	select USE_OF
> > > +	select MACH_MX28EVK
> > 
> > This should not be selected here.
> 
> Like other imx soc dt board files, the imx28-dt.c may need to use some bits
> like pinmux in mx28evk.c board file.
> 
> Yes, currently i can remove it since it is using uboot pinmux setting.
> But when add other devices support which is not covered in u-boot like
> flexcan, i may need to use non-dt board's pinmux setting.
> So maybe we can keep it first and remove it when totally not dependent
> on non-dt files.

I'd be all in for the "decremental approach" -- keep in whatever is needed and 
remove is as it becomes redundant.

> 
> > > + * The code contained herein is licensed under the GNU General Public
> > > + * License. You may obtain a copy of the GNU General Public License
> > > + * Version 2 or later at the following locations:
> > > + *
> > > + * http://www.opensource.org/licenses/gpl-license.html
> > > + * http://www.gnu.org/copyleft/gpl.html
> > > + */
> > > +
> > > +#include <linux/init.h>
> > > +#include <linux/irqdomain.h>
> > > +#include <linux/of_irq.h>
> > > +#include <linux/of_platform.h>
> > > +#include <asm/mach/arch.h>
> > > +#include <asm/mach/time.h>
> > > +#include <mach/common.h>
> > > +#include <mach/mx28.h>
> > > +
> > > +static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst
> > > = { +	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart",
> > > NULL), +	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR,
> > > "imx28-fec.0", NULL), +	OF_DEV_AUXDATA("fsl,imx28-fec",
> > > MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> > 
> > Why do you need the old names?
> 
> To keep align with the old clocks.
> See arch/arm/mach-mxs/clock-mx28.c:
> _REGISTER_CLOCK("imx28-fec.0", NULL, fec_clk)
> _REGISTER_CLOCK("imx28-fec.1", NULL, fec_clk)
> Is there any better way to avoid this?
> 
> > > +	{ /* sentinel */ }
> > > +};
> > > +
> > > +static void __init imx28_init(void)
> > > +{
> > > +	of_platform_populate(NULL, of_default_bus_match_table,
> > > +			     imx28_auxdata_lookup, NULL);
> > > +}
> > > +
> > > +static const struct of_device_id icoll_of_match[] __initconst = {
> > > +	{ .compatible = "fsl,imx28-icoll", },
> > > +	{},
> > > +};
> > > +
> > > +static void __init imx28_dt_init_irq(void)
> > > +{
> > > +	irq_domain_generate_simple(icoll_of_match, MX28_ICOLL_BASE_ADDR, 0);
> > 
> > Please do "proper" domain support for the interrupt controller and use
> > of_irq_init.
> 
> Ok, i will see it.
> 
> For others, will fix them all.
> Thanks for the review.
> 
> Regards
> Dong Aisheng


Best regards,
Marek Vasut
