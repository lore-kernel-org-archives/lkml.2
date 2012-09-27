Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2I0HcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:32:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:23358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab2I0HcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="198436949"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 0/7] dw_dmac: split the driver and introduce PCI part
Date: Thu, 27 Sep 2012 10:31:54 +0300
Message-Id: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is dedicated to support different platform devices via the same
core driver. In our case the dw_dmac could be used as a PCI device, regular
embedded device or something else. This split allows to support the controller
connected to any bus by adding a little piece of code without duplicating a
core driver functionality.

Since v2:
 - use git format-patch -C -M to avoid long useless patches
 - substitute DRIVER macro to a normal structure definition in the
   dw_dmac_pci.c
 - split patch 1/4 to few independent pieces with their own descriptions

Andy Shevchenko (2):
  dma: move dw_dmac driver to an own directory
  MAINTAINERS: add recently created files to dw_dmac section

Heikki Krogerus (5):
  dmaengine: dw_dmac: use helper macro module_platform_driver()
  dmaengine: dw_dmac: add module alias
  dmaengine: dw_dmac: remove CLK dependency
  dmaengine: dw_dmac: amend description and indentation
  dmaengine: dw_dmac: add PCI part of the driver

 MAINTAINERS                         |    4 +-
 drivers/dma/Kconfig                 |   10 ++-
 drivers/dma/Makefile                |    2 +-
 drivers/dma/dw/Makefile             |    2 +
 drivers/dma/{ => dw}/dw_dmac.c      |   23 +++----
 drivers/dma/dw/dw_dmac_pci.c        |  126 +++++++++++++++++++++++++++++++++++
 drivers/dma/{ => dw}/dw_dmac_regs.h |    0
 7 files changed, 148 insertions(+), 19 deletions(-)
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{ => dw}/dw_dmac.c (99%)
 create mode 100644 drivers/dma/dw/dw_dmac_pci.c
 rename drivers/dma/{ => dw}/dw_dmac_regs.h (100%)

-- 
1.7.10.4

