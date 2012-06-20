Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2FTQaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:30:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38349 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab2FTQaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <7758b679-088d-4a81-a7c6-2d6f1bef1262@AM1EHSMHS004.ehs.local>
References: <7758b679-088d-4a81-a7c6-2d6f1bef1262@AM1EHSMHS004.ehs.local>
Date: Wed, 20 Jun 2012 09:30:17 -0700
Message-ID: <CAB9O=CMH9oaNHAxc714ZzsS1bzpWUvvLPUAntbw6aVFO_+oNwQ@mail.gmail.com>
Subject: Fwd: FW: [PATCH v2] arm: zynq: Support GIC OF initialization
From: John Linn <johnhlinn@gmail.com>
To: monstr@monstr.eu, robherring2@gmail.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Wednesday, June 20, 2012 5:30 AM
> To: Michal Simek
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; John Linn;
> linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2] arm: zynq: Support GIC OF initialization
>
> On 06/20/2012 01:24 AM, Michal Simek wrote:
> > Zynq is OF driven platfrom which requires OF initialization.
> >
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: John Linn <johnhlinn@gmail.com>

>
> >
> > ---
> > v2: Remove also corresponding defines
> > ---
> >  arch/arm/mach-zynq/common.c                |    7 ++++++-
> >  arch/arm/mach-zynq/include/mach/zynq_soc.h |    2 --
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/mach-zynq/common.c
b/arch/arm/mach-zynq/common.c
> > index 17d68d6..7941544 100644
> > --- a/arch/arm/mach-zynq/common.c
> > +++ b/arch/arm/mach-zynq/common.c
> > @@ -56,12 +56,17 @@ static void __init xilinx_init_machine(void)
> >     of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
> >  }
> >
> > +static const struct of_device_id zynq_dt_irq_match[] __initconst =
{
> > +   { .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
> > +   { }
> > +};
> > +
> >  /**
> >   * xilinx_irq_init() - Interrupt controller initialization for the
> GIC.
> >   */
> >  static void __init xilinx_irq_init(void)
> >  {
> > -   gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
> > +   of_irq_init(zynq_dt_irq_match);
> >  }
> >
> >  /* The minimum devices needed to be mapped before the VM system is
up
> and
> > diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > index 6ff7015..eab11a0 100644
> > --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > @@ -41,9 +41,7 @@
> >
> >  #define TTC0_BASE                  IOMEM(TTC0_VIRT)
> >  #define SCU_PERIPH_BASE                    IOMEM(SCU_PERIPH_VIRT)
> > -#define SCU_GIC_CPU_BASE           (SCU_PERIPH_BASE + 0x100)
> >  #define SCU_CPU_TIMER_BASE         (SCU_PERIPH_BASE + 0x600)
> > -#define SCU_GIC_DIST_BASE          (SCU_PERIPH_BASE + 0x1000)
> >  #define PL310_L2CC_BASE                    IOMEM(PL310_L2CC_VIRT)
> >
> >  /*
>
