Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2A1Sib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 13:38:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47457 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2A1Si3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 13:38:29 -0500
Message-ID: <4F2440A2.5080601@gmail.com>
Date: Sat, 28 Jan 2012 12:38:26 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 03:35 PM, Grant Likely wrote:
> Hey everyone,
> 
> This patch series is ready for much wider consumption now.  I'd like
> to get it into linux-next ASAP because there will be ARM board support
> depending on it.  I'll wait a few days before I ask Stephen to pull
> this in.
> 
> Stephen/Milton/Ben, any testing you can help with here would be
> appreciated since you've got access to a wider variety of Power
> machines than I do.
> 
> Thomas, I think it makes sense to maintain this in a separate branch
> from other irq changes until the next merge window.  If you prefer,
> I'm happy to maintain this branch until then.
> 

I picked up your irqdomain/next branch and it doesn't compile:

  CC      kernel/irq/irqdomain.o
kernel/irq/irqdomain.c: In function ‘irq_create_mapping’:
kernel/irq/irqdomain.c:403:47: error: ‘irq’ undeclared (first use in
this function)
kernel/irq/irqdomain.c:403:47: note: each undeclared identifier is
reported only once for each function it app

Rob

> Cheers,
> g.
> 
> The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:
> 
>   Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)
> 
> are available in the git repository at:
>   git://git.secretlab.ca/git/linux-2.6 irqdomain/next
> 
> Grant Likely (24):
>       irq_domain: add documentation and MAINTAINERS entry.
>       dt: Make irqdomain less verbose
>       irq_domain: Make irq_domain structure match powerpc's irq_host
>       irq_domain: convert microblaze from irq_host to irq_domain
>       irq_domain/powerpc: Use common irq_domain structure instead of irq_host
>       irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
>       irq_domain/powerpc: Eliminate virq_is_host()
>       irq_domain: Move irq_domain code from powerpc to kernel/irq
>       irqdomain: remove NO_IRQ from irq domain code
>       irq_domain: Remove references to old irq_host names
>       irq_domain: Replace irq_alloc_host() with revmap-specific initializers
>       irq_domain: Add support for base irq and hwirq in legacy mappings
>       irq_domain: Remove 'new' irq_domain in favour of the ppc one
>       irq_domain: Remove irq_domain_add_simple()
>       irq_domain: Create common xlate functions that device drivers can use
>       irq_domain: constify irq_domain_ops
>       irq_domain/c6x: constify irq_domain structures
>       irq_domain/c6x: Use library of xlate functions
>       irq_domain/powerpc: constify irq_domain_ops
>       irqdomain/powerpc: Replace custom xlate functions with library functions
>       irq_domain/x86: Convert x86 (embedded) to use common irq_domain
>       irq_domain: Include hwirq number in /proc/interrupts
>       irq_domain: remove "hint" when allocating irq numbers
>       irq_domain: mostly eliminate slow-path revmap lookups
> 
> Mark Salter (1):
>       irq_domain/c6x: Convert c6x to use generic irq_domain support.
> 
>  Documentation/IRQ-domain.txt                     |  113 +++
>  MAINTAINERS                                      |    9 +
>  arch/arm/common/gic.c                            |   95 ++--
>  arch/arm/common/vic.c                            |   16 +-
>  arch/arm/include/asm/hardware/gic.h              |    4 +-
>  arch/arm/include/asm/hardware/vic.h              |    2 +
>  arch/arm/mach-exynos/common.c                    |    2 +-
>  arch/arm/mach-imx/mach-imx6q.c                   |    3 +-
>  arch/arm/mach-msm/board-msm8x60.c                |    8 +-
>  arch/arm/mach-mx5/imx51-dt.c                     |    4 +-
>  arch/arm/mach-mx5/imx53-dt.c                     |    4 +-
>  arch/arm/mach-omap2/board-generic.c              |    2 +-
>  arch/arm/mach-prima2/irq.c                       |    2 +-
>  arch/arm/mach-versatile/core.c                   |    5 +-
>  arch/c6x/Kconfig                                 |    1 +
>  arch/c6x/include/asm/irq.h                       |  245 +-------
>  arch/c6x/kernel/irq.c                            |  612 +----------------
>  arch/c6x/platforms/megamod-pic.c                 |   25 +-
>  arch/microblaze/include/asm/irq.h                |    4 +-
>  arch/microblaze/kernel/irq.c                     |    2 +-
>  arch/microblaze/kernel/setup.c                   |    2 -
>  arch/powerpc/Kconfig                             |    1 +
>  arch/powerpc/include/asm/ehv_pic.h               |    2 +-
>  arch/powerpc/include/asm/i8259.h                 |    2 +-
>  arch/powerpc/include/asm/irq.h                   |  247 +-------
>  arch/powerpc/include/asm/mpic.h                  |    2 +-
>  arch/powerpc/include/asm/xics.h                  |    2 +-
>  arch/powerpc/kernel/irq.c                        |  617 +----------------
>  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |   12 +-
>  arch/powerpc/platforms/52xx/media5200.c          |   15 +-
>  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |   16 +-
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   12 +-
>  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |   14 +-
>  arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   15 +-
>  arch/powerpc/platforms/86xx/gef_pic.c            |   15 +-
>  arch/powerpc/platforms/cell/axon_msi.c           |   29 +-
>  arch/powerpc/platforms/cell/beat_interrupt.c     |   16 +-
>  arch/powerpc/platforms/cell/interrupt.c          |   16 +-
>  arch/powerpc/platforms/cell/spider-pic.c         |   14 +-
>  arch/powerpc/platforms/embedded6xx/flipper-pic.c |   30 +-
>  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   35 +-
>  arch/powerpc/platforms/iseries/irq.c             |   11 +-
>  arch/powerpc/platforms/powermac/pic.c            |   26 +-
>  arch/powerpc/platforms/powermac/smp.c            |    9 +-
>  arch/powerpc/platforms/ps3/interrupt.c           |   11 +-
>  arch/powerpc/platforms/wsp/opb_pic.c             |   26 +-
>  arch/powerpc/sysdev/cpm1.c                       |    9 +-
>  arch/powerpc/sysdev/cpm2_pic.c                   |   23 +-
>  arch/powerpc/sysdev/ehv_pic.c                    |   14 +-
>  arch/powerpc/sysdev/fsl_msi.c                    |   10 +-
>  arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
>  arch/powerpc/sysdev/i8259.c                      |   15 +-
>  arch/powerpc/sysdev/ipic.c                       |   31 +-
>  arch/powerpc/sysdev/ipic.h                       |    2 +-
>  arch/powerpc/sysdev/mpc8xx_pic.c                 |   11 +-
>  arch/powerpc/sysdev/mpic.c                       |   17 +-
>  arch/powerpc/sysdev/mpic_msi.c                   |    2 +-
>  arch/powerpc/sysdev/mv64x60_pic.c                |   11 +-
>  arch/powerpc/sysdev/qe_lib/qe_ic.c               |   26 +-
>  arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
>  arch/powerpc/sysdev/tsi108_pci.c                 |   22 +-
>  arch/powerpc/sysdev/uic.c                        |   26 +-
>  arch/powerpc/sysdev/xics/xics-common.c           |   28 +-
>  arch/powerpc/sysdev/xilinx_intc.c                |   19 +-
>  arch/x86/Kconfig                                 |    2 +
>  arch/x86/include/asm/irq_controller.h            |   12 -
>  arch/x86/include/asm/prom.h                      |   10 -
>  arch/x86/kernel/devicetree.c                     |  101 +--
>  drivers/gpio/gpio-mpc8xxx.c                      |   30 +-
>  drivers/mfd/twl-core.c                           |   12 +-
>  drivers/net/phy/mdio-gpio.c                      |    4 +-
>  include/linux/irqdomain.h                        |  190 ++++--
>  kernel/irq/irqdomain.c                           |  816 +++++++++++++++++++---
>  kernel/irq/proc.c                                |    3 +
>  74 files changed, 1334 insertions(+), 2471 deletions(-)
>  create mode 100644 Documentation/IRQ-domain.txt
>  delete mode 100644 arch/x86/include/asm/irq_controller.h
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

