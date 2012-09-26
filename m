Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2IZMkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:40:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:3832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab2IZMkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="226764229"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/4] dw_dmac: split the driver and introduce PCI part
Date: Wed, 26 Sep 2012 15:40:33 +0300
Message-Id: <1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is dedicated to support different platform devices via the same
core driver. In our case the dw_dmac could be used as a PCI device, regular
embedded device or something else. This split allows to support the controller
connected to any bus by adding a little piece of code without duplicating a
core driver functionality.

Since v1:
 - indentation fix in MAINTAINERS is droped away to separate patch (not related
   to this series)
 - CLK framework uses stubs for platforms w/o it, in the result it eliminates 3
   patches and produces 1
 - driver files are moved to an own folder

Andy Shevchenko (2):
  dma: move dw_dmac driver to an own directory
  MAINTAINERS: add recently created files to dw_dmac section

Heikki Krogerus (2):
  dmaengine: dw_dmac: convert to platform driver
  dmaengine: dw_dmac: Add PCI part of the driver

 MAINTAINERS                   |    4 +-
 drivers/dma/Kconfig           |   11 +-
 drivers/dma/Makefile          |    2 +-
 drivers/dma/dw/Makefile       |    2 +
 drivers/dma/dw/dw_dmac.c      | 1720 ++++++++++++++++++++++++++++++++++++++++
 drivers/dma/dw/dw_dmac_pci.c  |  127 +++
 drivers/dma/dw/dw_dmac_regs.h |  294 +++++++
 drivers/dma/dw_dmac.c         | 1727 -----------------------------------------
 drivers/dma/dw_dmac_regs.h    |  294 -------
 9 files changed, 2155 insertions(+), 2026 deletions(-)
 create mode 100644 drivers/dma/dw/Makefile
 create mode 100644 drivers/dma/dw/dw_dmac.c
 create mode 100644 drivers/dma/dw/dw_dmac_pci.c
 create mode 100644 drivers/dma/dw/dw_dmac_regs.h
 delete mode 100644 drivers/dma/dw_dmac.c
 delete mode 100644 drivers/dma/dw_dmac_regs.h

-- 
1.7.10.4

