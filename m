Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2KWPMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:12:02 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45166 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2KWPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:10:04 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH v2 0/8] enable support for AMBA drivers under x86
Date: Fri, 23 Nov 2012 16:08:22 +0100
Message-Id: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is v2 of a patchset submitted on Sep 14th
(see https://lkml.org/lkml/2012/9/14/412).
The only changes are:

* Rebased to next-20121115.
* "gpio: pl061 depends on ARM" : changelog fixed as per Sergei Shtylyov's
  comments (see https://lkml.org/lkml/2012/9/14/471).
* "drivers/amba: add support for a PCI bridge" : pci_amba_probe(), avoided
  unnecessary double return statement.

Acked by situation:

"DMA: PL330: use prefix in reg names to build under x86" has already been
acked by Vinod Koul (see https://lkml.org/lkml/2012/9/16/271) and
Linus Walleij (see https://lkml.org/lkml/2012/9/16/93).

"mmc: use the new <linux/sizes.h>" has already been acked by David Brown
(see https://lkml.org/lkml/2012/9/14/613)

"pl080.h: moved from arm/include/asm/hardware to include/linux/amba/" has
already been acked by Linus Walleij (see https://lkml.org/lkml/2012/9/16/92).

Regards
Davide


Alessandro Rubini (7):
  DMA: PL330: use prefix in reg names to build under x86
  gpio: pl061 depends on ARM
  pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
  watchdog: sp805_wdt depends on ARM
  mmc: use the new <linux/sizes.h>
  drivers/amba: add support for a PCI bridge
  x86: add CONFIG_ARM_AMBA, selected by STA2X11

Davide Ciminaghi (1):
  mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep

 arch/arm/include/asm/hardware/pl080.h |  146 ---------
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c     |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c     |    2 +-
 arch/x86/Kconfig                      |    4 +
 drivers/Kconfig                       |    2 +
 drivers/amba/Kconfig                  |   10 +
 drivers/amba/Makefile                 |    1 +
 drivers/amba/pci-amba.c               |   93 ++++++
 drivers/dma/amba-pl08x.c              |    2 +-
 drivers/dma/pl330.c                   |  581 +++++++++++++++++----------------
 drivers/gpio/Kconfig                  |    2 +-
 drivers/mmc/host/mmci.c               |   10 +-
 drivers/mmc/host/msm_sdcc.c           |    2 +-
 drivers/mmc/host/mvsdio.c             |    2 +-
 drivers/mmc/host/mxcmmc.c             |    2 +-
 drivers/mmc/host/pxamci.c             |    3 +-
 drivers/watchdog/Kconfig              |    2 +-
 include/linux/amba/pl080.h            |  146 +++++++++
 19 files changed, 563 insertions(+), 451 deletions(-)
 delete mode 100644 arch/arm/include/asm/hardware/pl080.h
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c
 create mode 100644 include/linux/amba/pl080.h

-- 
1.7.10.4

