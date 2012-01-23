Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2AWVxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:53:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63952 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab2AWVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:53:40 -0500
Message-ID: <4F1DD6DF.4080706@gmail.com>
Date: Mon, 23 Jan 2012 15:53:35 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Shawn Guo <shawn.guo@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFCv2 00/14]
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 03:07 PM, Grant Likely wrote:
> 
> Hey everyone,
> 
> Here's the second RFC for the irq_domain patches.  I could use some
> help testing now.  I still expect there will be a few bugs.  The
> series is based on v3.3-rc1, and I've pushed it out to my git server:
> 
> git://git.secretlab.ca/git/linux-2.6.git irqdomain/next

Can you post to linux-arm-kernel too so people are aware of this work
and stop posting dead-end irqdomain patches.

I tested what you had as of this morning and it works fine for me. Looks
like the only diff is the VExpress code. I'm working on rebasing my
domain support for generic irqchip now.

Rob

> On Wed, Jan 11, 2012 at 1:22 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Here are the patches that I've been working on to finish up the creation
>> of the generic irq_domain infrastructure.
>>
>> I'm taking a different approach that I originally intended.
>> Originally I intended to start with the basic design of irq_host from
>> powerpc, but there were some things about the implementation that I
>> didn't like, so I was going to reimplement those bits and then migrate
>> powerpc over to use it.  That was a mistake and would have resulted in
>> a lot more work.  Instead, I should have started with the powerpc
>> irq_host code, moved it to a common location, and then reworked it in
>> place.  The powerpc code is working and well tested.  It is a lot less
>> risky to use it as the starting point with a nicely bisectable series
>> of changes to make it do what other architectures need.
> 
> [RFCv2 01/14] irq_domain: add documentation and MAINTAINERS entry.
> [RFCv2 02/14] dt: Make irqdomain less verbose
> [RFCv2 03/14] irq_domain: Make irq_domain structure match powerpc's
> [RFCv2 04/14] irq_domain: convert microblaze from irq_host to
> [RFCv2 05/14] irq_domain/powerpc: Use common irq_domain structure
> [RFCv2 06/14] irq_domain/powerpc: eliminate irq_map; use
> [RFCv2 07/14] irq_domain/powerpc: Eliminate virq_is_host()
> [RFCv2 08/14] irq_domain: Move irq_domain code from powerpc to
> [RFCv2 09/14] irqdomain: remove NO_IRQ from irq domain code
> [RFCv2 10/14] irq_domain: Remove references to old irq_host names
> [RFCv2 11/14] irq_domain: Replace irq_alloc_host() with
> [RFCv2 12/14] irq_domain: Add support for base irq and hwirq in
> [RFCv2 13/14] irq_domain: Remove 'new' irq_domain in favour of the
> [RFCv2 14/14] irq_domain: Remove irq_domain_add_simple()
> 
>  Documentation/IRQ-domain.txt                     |  113 ++++
>  MAINTAINERS                                      |    9 +
>  arch/arm/common/gic.c                            |   97 ++--
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
>  arch/microblaze/include/asm/irq.h                |    4 +-
>  arch/microblaze/kernel/irq.c                     |    2 +-
>  arch/microblaze/kernel/setup.c                   |    2 -
>  arch/powerpc/Kconfig                             |    1 +
>  arch/powerpc/include/asm/ehv_pic.h               |    2 +-
>  arch/powerpc/include/asm/i8259.h                 |    2 +-
>  arch/powerpc/include/asm/irq.h                   |  247 +-------
>  arch/powerpc/include/asm/mpic.h                  |    2 +-
>  arch/powerpc/include/asm/xics.h                  |    2 +-
>  arch/powerpc/kernel/irq.c                        |  617 +------------------
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
>  arch/powerpc/platforms/powermac/pic.c            |   15 +-
>  arch/powerpc/platforms/powermac/smp.c            |    9 +-
>  arch/powerpc/platforms/ps3/interrupt.c           |   11 +-
>  arch/powerpc/platforms/wsp/opb_pic.c             |   15 +-
>  arch/powerpc/sysdev/cpm1.c                       |    9 +-
>  arch/powerpc/sysdev/cpm2_pic.c                   |   11 +-
>  arch/powerpc/sysdev/ehv_pic.c                    |   14 +-
>  arch/powerpc/sysdev/fsl_msi.c                    |   10 +-
>  arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
>  arch/powerpc/sysdev/i8259.c                      |   15 +-
>  arch/powerpc/sysdev/ipic.c                       |   15 +-
>  arch/powerpc/sysdev/ipic.h                       |    2 +-
>  arch/powerpc/sysdev/mpc8xx_pic.c                 |   11 +-
>  arch/powerpc/sysdev/mpic.c                       |   17 +-
>  arch/powerpc/sysdev/mpic_msi.c                   |    2 +-
>  arch/powerpc/sysdev/mv64x60_pic.c                |   11 +-
>  arch/powerpc/sysdev/qe_lib/qe_ic.c               |   13 +-
>  arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
>  arch/powerpc/sysdev/tsi108_pci.c                 |   13 +-
>  arch/powerpc/sysdev/uic.c                        |   14 +-
>  arch/powerpc/sysdev/xics/xics-common.c           |   25 +-
>  arch/powerpc/sysdev/xilinx_intc.c                |   19 +-
>  drivers/gpio/gpio-mpc8xxx.c                      |   15 +-
>  drivers/mfd/twl-core.c                           |   12 +-
>  include/linux/irqdomain.h                        |  180 ++++--
>  kernel/irq/irqdomain.c                           |  757 ++++++++++++++++++----
>  64 files changed, 1207 insertions(+), 1414 deletions(-)
