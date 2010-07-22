Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0GVWaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:30:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0GVWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:30:04 -0400
Subject: [PATCH 0/4] Replace reference to of_device with platform_device in
	arch and drivers/of/* code
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:01 -0600
Message-ID: <20100722222600.21557.34167.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes a lot of references to struct of_device which is
just a #define alias to struct platform_device.  It also replaces usage
of to_of_device() with to_platform_device().  There shouldn't be anything
risky or earth shattering here.  Certainly no functional changes.  I'll
be putting it into my experimental branch for compile testing on multiple
architectures before pushing it out to linux-next next week.

Similar patches to change over drivers/* will come later.

g.

---

Grant Likely (4):
      of/device: Replace of_device with platform_device in includes and core code
      powerpc: remove references to of_device and to_of_device
      sparc: remove references to of_device and to_of_device
      microblaze: remove references to of_device and to_of_device


 arch/microblaze/kernel/of_platform.c          |    6 +++---
 arch/powerpc/include/asm/macio.h              |    2 +-
 arch/powerpc/kernel/ibmebus.c                 |    8 ++++----
 arch/powerpc/kernel/of_platform.c             |    8 ++++----
 arch/powerpc/platforms/512x/clock.c           |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |    6 +++---
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |    4 ++--
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |    6 +++---
 arch/powerpc/platforms/82xx/ep8248e.c         |    4 ++--
 arch/powerpc/platforms/83xx/suspend.c         |    6 +++---
 arch/powerpc/platforms/cell/axon_msi.c        |    4 ++--
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    4 ++--
 arch/powerpc/sysdev/axonram.c                 |   12 ++++++------
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |    7 +++----
 arch/powerpc/sysdev/fsl_msi.c                 |    4 ++--
 arch/powerpc/sysdev/fsl_pmc.c                 |    3 ++-
 arch/powerpc/sysdev/fsl_rio.c                 |    4 ++--
 arch/powerpc/sysdev/pmi.c                     |    6 +++---
 arch/powerpc/sysdev/qe_lib/qe.c               |    5 +++--
 arch/sparc/include/asm/floppy_64.h            |    6 +++---
 arch/sparc/include/asm/parport.h              |    4 ++--
 arch/sparc/include/asm/prom.h                 |    2 +-
 arch/sparc/kernel/apc.c                       |    4 ++--
 arch/sparc/kernel/auxio_64.c                  |    3 ++-
 arch/sparc/kernel/central.c                   |    4 ++--
 arch/sparc/kernel/chmc.c                      |   12 ++++++------
 arch/sparc/kernel/ioport.c                    |    2 +-
 arch/sparc/kernel/of_device_32.c              |   14 +++++++-------
 arch/sparc/kernel/of_device_64.c              |   16 ++++++++--------
 arch/sparc/kernel/of_device_common.c          |   14 +++++++-------
 arch/sparc/kernel/pci.c                       |    4 ++--
 arch/sparc/kernel/pci_fire.c                  |    4 ++--
 arch/sparc/kernel/pci_impl.h                  |    2 +-
 arch/sparc/kernel/pci_psycho.c                |    6 +++---
 arch/sparc/kernel/pci_sabre.c                 |    6 +++---
 arch/sparc/kernel/pci_schizo.c                |   10 +++++-----
 arch/sparc/kernel/pci_sun4v.c                 |    4 ++--
 arch/sparc/kernel/pmc.c                       |    2 +-
 arch/sparc/kernel/power.c                     |    2 +-
 arch/sparc/kernel/prom_irqtrans.c             |    2 +-
 arch/sparc/kernel/psycho_common.c             |    2 +-
 arch/sparc/kernel/psycho_common.h             |    2 +-
 arch/sparc/kernel/sbus.c                      |   16 ++++++++--------
 arch/sparc/kernel/time_32.c                   |    2 +-
 arch/sparc/kernel/time_64.c                   |    6 +++---
 arch/sparc/mm/io-unit.c                       |    4 ++--
 arch/sparc/mm/iommu.c                         |    4 ++--
 drivers/of/device.c                           |   22 +++++++++++-----------
 drivers/of/platform.c                         |   24 ++++++++++++------------
 include/linux/of_device.h                     |   10 +++++-----
 include/linux/of_platform.h                   |   16 ++++++++--------
 51 files changed, 167 insertions(+), 165 deletions(-)

