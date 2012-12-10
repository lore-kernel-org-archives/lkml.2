Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2LJNpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:45:53 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35731 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2LJNoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:44:12 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH v4 0/7] enable support for AMBA drivers under x86
Date: Mon, 10 Dec 2012 14:42:29 +0100
Message-Id: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is v4 of a patchset already submitted on Sep 14th
(see https://lkml.org/lkml/2012/9/14/412) and
Nov 23rd (see https://lkml.org/lkml/2012/11/23/272).
Then 1/8 and 3/8 only were resubmitted (as v3) with the following changes:

* The output of git diff --word-diff was added to 1/8 as additional
  information for reviewers (see https://lkml.org/lkml/2012/11/23/415).
* 3/8 was generated with git format-patch -C -M to detect copies and moves
  (see https://lkml.org/lkml/2012/11/23/404).

Changes in v4 are:

* Rebased to next-20121210
* All patches generated with git format-patch -C -M.
* "DMA: PL330: use prefix in reg names to build under x86" : only registers
  names were prefixed (no PL330_ prefix for bitfields), as requested by
  Jassi Brar (see https://lkml.org/lkml/2012/11/24/46). Please note that this
  change was done by myself. I let Alessandro as the patch author, and just
  added my Signed-off-by with a very short explanation of my change. I'm not
  sure I did the right thing because, although my change is a small one from
  a logical point of view, it results in a much smaller patch, so this version
  is actually very different from v3.
* "gpio: pl061 depends on ARM": removed as it has already applied to
  linux-next (see https://lkml.org/lkml/2012/12/1/77)

Acked-by/Reviewed-by situation:

v1:

"DMA: PL330: use prefix in reg names to build under x86"
Acked by Vinod Koul (see https://lkml.org/lkml/2012/9/16/271) and
Linus Walleij (see https://lkml.org/lkml/2012/9/16/93).

"mmc: use the new <linux/sizes.h>"
Acked by David Brown (see https://lkml.org/lkml/2012/9/14/613)

"pl080.h: moved from arm/include/asm/hardware to include/linux/amba/"
Acked by Linus Walleij (see https://lkml.org/lkml/2012/9/16/92).


v2:

"watchdog: sp805_wdt depends on ARM"
Acked by Viresh Kumar (see https://lkml.org/lkml/2012/11/23/296)
Acked by Linus Walleij (see https://lkml.org/lkml/2012/11/28/259).

"mmc: use the new <linux/sizes.h>"
Reviewed by Viresh Kumar (see https://lkml.org/lkml/2012/11/23/328)
Acked by David Brown (see https://lkml.org/lkml/2012/11/26/625)
Acked by Linus Walleij (see https://lkml.org/lkml/2012/12/1/105).

"mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep"
Acked by Linus Walleij (see https://lkml.org/lkml/2012/11/28/266)
Acked by Will Deacon (see https://lkml.org/lkml/2012/12/3/202).

"pl080.h: moved from arm/include/asm/hardware to include/linux/amba/"
Acked by Linus Walleij (see https://lkml.org/lkml/2012/11/28/265).


Alessandro Rubini (6):
  DMA: PL330: use prefix in reg names to build under x86
  pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
  watchdog: sp805_wdt depends on ARM
  mmc: use the new <linux/sizes.h>
  drivers/amba: add support for a PCI bridge
  x86: add CONFIG_ARM_AMBA, selected by STA2X11

Davide Ciminaghi (1):
  mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep

 arch/arm/mach-s3c64xx/dma.c                        |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c                  |    2 +-
 arch/x86/Kconfig                                   |    4 +
 drivers/Kconfig                                    |    2 +
 drivers/amba/Kconfig                               |   10 ++
 drivers/amba/Makefile                              |    1 +
 drivers/amba/pci-amba.c                            |   93 +++++++++++++++++
 drivers/dma/amba-pl08x.c                           |    2 +-
 drivers/dma/pl330.c                                |  107 ++++++++++----------
 drivers/mmc/host/mmci.c                            |   10 +-
 drivers/mmc/host/msm_sdcc.c                        |    2 +-
 drivers/mmc/host/mvsdio.c                          |    2 +-
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mmc/host/pxamci.c                          |    3 +-
 drivers/watchdog/Kconfig                           |    2 +-
 .../asm/hardware => include/linux/amba}/pl080.h    |    2 +-
 17 files changed, 179 insertions(+), 69 deletions(-)
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c
 rename {arch/arm/include/asm/hardware => include/linux/amba}/pl080.h (99%)

-- 
1.7.10.4

