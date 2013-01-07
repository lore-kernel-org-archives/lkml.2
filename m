Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3AGKlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:33340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3AGKlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="188437097"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 00/11] spi/pxa2xx: add Intel Lynxpoint SPI controller support
Date: Mon,  7 Jan 2013 12:44:29 +0200
Message-Id: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Intel Lynxpoint (the PCH used with Haswell) we have two SPI controllers
that reside in the Low Power Subsystem of the PCH. The hardware is mostly
compliant with PXA2xx SPI controller except that there are few additional
registers. Those are described in patch [10/11].

The patches [1-6/11] implement the foundation:

	* allow building the driver on 64-bit kernel
	* allow passing the ssp_device from platform data
	* allow passing clock rate from platform data on arches that don't
	  support common clk framework like x86
	* separate the PXA private DMA implementation out

The following patches [7-11/11] then build on top of this foundation so
that we support the generic DMA engine API, runtime power management, and
finally the Intel Lynxpoint SPI controller that is discoverable from ACPI
namespace.

Tested with DMA and PIO modes on Haswell/Lynxpoint machine.

This shouldn't break anything but I haven't been able to test on PXA (due
to lack of hardware) so I would appreciate if someone who has the hardware
could try them out.

Note that checkpatch.pl gives few warnings about using CamelCase for
identifiers but I decided to be consistent with the original style instead.
Let me know if it is not acceptable and I'll change them.

The series is based on 3.8-rc2.

Mika Westerberg (11):
  spi/pxa2xx: allow building on a 64-bit kernel
  spi/pxa2xx: convert to the pump message infrastructure
  spi/pxa2xx-pci: switch to use pcim_* interfaces
  spi/pxa2xx: embed the ssp_device to platform data
  spi/pxa2xx: make clock rate configurable from platform data
  spi/pxa2xx: use the private DMA API only when CONFIG_ARCH_PXA is set
  spi/pxa2xx: add support for DMA engine
  spi/pxa2xx: add support for runtime PM
  spi/pxa2xx: add support for SPI_LOOP
  spi/pxa2xx: add support for Intel Low Power Subsystem SPI
  spi/pxa2xx: add support for Lynxpoint SPI controllers

 drivers/spi/Kconfig            |    4 +-
 drivers/spi/spi-pxa2xx-pci.c   |  134 +---
 drivers/spi/spi-pxa2xx.c       | 1516 +++++++++++++++++++++++++++-------------
 include/linux/pxa2xx_ssp.h     |   18 +
 include/linux/spi/pxa2xx_spi.h |  109 +--
 5 files changed, 1103 insertions(+), 678 deletions(-)

-- 
1.7.10.4

