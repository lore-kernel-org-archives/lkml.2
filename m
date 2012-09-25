Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2IYMNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:13:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:21901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2IYMNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:13:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="226185252"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv1 0/6] dw_dmac: split the driver and introduce PCI part
Date: Tue, 25 Sep 2012 15:13:04 +0300
Message-Id: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is dedicated to support different platform devices via the same
core driver. In our case the dw_dmac could be used as a PCI device, regular
embedded device or something else. This split allows to support the controller
connected to any bus by adding a little piece of code without duplicating a
core driver functionality.

Andy Shevchenko (2):
  MAINTAINERS: fix indentation for Viresh Kumar
  MAINTAINERS: add recently created files to dw_dmac section

Heikki Krogerus (4):
  dmaengine: dw_dmac: Remove clk API dependency
  dmaengine: dw_dmac: add driver for Atmel AT32
  dmaengine: dw_dmac: Add PCI part of the driver
  avr32: at32ap700x: rename DMA controller

 MAINTAINERS                         |   19 +++--
 arch/avr32/mach-at32ap/at32ap700x.c |   20 ++---
 drivers/dma/Kconfig                 |   19 ++++-
 drivers/dma/Makefile                |    2 +
 drivers/dma/dw_dmac.c               |   41 ++--------
 drivers/dma/dw_dmac_at32.c          |  151 +++++++++++++++++++++++++++++++++++
 drivers/dma/dw_dmac_pci.c           |  130 ++++++++++++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h          |    1 -
 8 files changed, 327 insertions(+), 56 deletions(-)
 create mode 100644 drivers/dma/dw_dmac_at32.c
 create mode 100644 drivers/dma/dw_dmac_pci.c

-- 
1.7.10.4

