Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966302Ab2CANar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:30:47 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62286 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966247Ab2CANaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:30:46 -0500
Date: Thu, 1 Mar 2012 14:28:24 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 0/4] Initial steps to compile AMBA for x86
Message-ID: <cover.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on the sta2x11 I/O Hub, which is basically a bridge from
PCIe to AMBA.  While current code uses PCI drivers for all the
PrimeCell devices (with a lot of code duplication), I think we should
be able to compile native amba drivers. The chip has uart, spi, mmc, i2c
and dma cells, for which an AMBA driver is already in the kernel.

This patch-set is the first steps needed to build amba drivers for
x86.  I'm currently using the pl011 UART as a testbed, and it's up on
my system (with other not-ready-to-be-published patches).

As for sizes, there are a number of users of <asm/sizes.h>. If these
initial patches are accepted, I'll take care to convert other stuff,
add a #warning to asm/sizes.h and remove it after a pair of releases.

The patches have been build-tested under ARM with versatile_defconfig,
at91sam9263_defconfig, vexpress_defconfig and realview-smp_defconfig
-- as well as sta2x11 on x86.

Alessandro Rubini (4):
  x86: add NO_IRQ macro
  sizes.h: move from asm-generic to <linux/sizes.h>
  amba: use the new linux/sizes.h
  ARM: use the new linux/sizes.h

 arch/arm/include/asm/memory.h |    2 +-
 arch/arm/mm/dma-mapping.c     |    2 +-
 arch/arm/mm/init.c            |    2 +-
 arch/arm/mm/ioremap.c         |    2 +-
 arch/arm/mm/mmu.c             |    2 +-
 arch/x86/include/asm/irq.h    |    2 +
 drivers/amba/bus.c            |    2 +-
 include/asm-generic/sizes.h   |   49 +---------------------------------------
 include/linux/sizes.h         |   47 +++++++++++++++++++++++++++++++++++++++
 9 files changed, 57 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/sizes.h

-- 
1.7.7.2
