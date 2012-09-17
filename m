Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2IQHjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:53975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2IQHjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="205966830"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/7] dw_dmac: introduce autoconfiguration
Date: Mon, 17 Sep 2012 10:39:30 +0300
Message-Id: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patchset that allows to adapt the driver to the hardware
configuration during probe time. The hardware should have the specific optional
parameters enabled. Otherwise the driver will consider values stored in the
platform data.

Additionally it brings support of the software LLP transfers. It means that
normal linked list transfer is substituted by set of single block transfers
transparently to the user.

Comments are welcome.

Andy Shevchenko (7):
  dw_dmac: mark dwc_dump_chan_regs as inline
  dw_dmac: fill optional encoded parameters in register structure
  dw_dmac: get number of channels from hardware if possible
  dw_dmac: autoconfigure block_size or use platform data
  dw_dmac: autoconfigure data_width or get it via platform data
  dw_dmac: check if controller supports LLP
  dw_dmac: introduce software emulation of LLP transfers

 arch/arm/mach-spear13xx/spear13xx.c |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c |    3 +
 drivers/dma/dw_dmac.c               |  207 +++++++++++++++++++++++++++++------
 drivers/dma/dw_dmac_regs.h          |   48 ++++++++
 include/linux/dw_dmac.h             |    7 ++
 5 files changed, 235 insertions(+), 33 deletions(-)

-- 
1.7.10.4

