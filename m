Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3AJIxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:53:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:3284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab3AJIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244514068"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 00/11] patches against slave dma subsystem
Date: Thu, 10 Jan 2013 10:52:55 +0200
Message-Id: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recend to Vinod for review.

Since v1:
 - is_slave_xfer renamed to is_slave_direction
 - changelog fixed for "dma: dw_dmac: clear suspend bit during termination"
 - typo fixed in the changelog of "dw_dmac: backlink to dw_dma in dw_dma_chan
   is superfluous"

Andy Shevchenko (10):
  dmaengine: introduce is_slave_direction function
  dma: at_hdmac: check direction properly for cyclic transfers
  dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
  dma: ep93xx_dma: reuse is_slave_direction helper
  dma: ipu_idmac: reuse is_slave_direction helper
  dma: ste_dma40: reuse is_slave_direction helper
  dw_dmac: call .probe after we have a device in place
  dw_dmac: store direction in the custom channel structure
  dw_dmac: make usage of dw_dma_slave optional
  dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous

Heikki Krogerus (1):
  dma: dw_dmac: clear suspend bit during termination

 drivers/dma/at_hdmac.c      |   10 +++----
 drivers/dma/dw_dmac.c       |   62 ++++++++++++++++++++++++++++++-------------
 drivers/dma/dw_dmac_regs.h  |   17 ++++++------
 drivers/dma/ep93xx_dma.c    |    3 +--
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 drivers/dma/ste_dma40.c     |    2 +-
 include/linux/dmaengine.h   |    5 ++++
 7 files changed, 64 insertions(+), 37 deletions(-)

-- 
1.7.10.4

