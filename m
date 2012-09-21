Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2IUMF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:05:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:55548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2IUMFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="224857167"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/6] dw_dmac: introduce autoconfiguration
Date: Fri, 21 Sep 2012 15:05:43 +0300
Message-Id: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
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

Since v1:
 - addressed all Viresh's comments.

Andy Shevchenko (6):
  dw_dmac: mark dwc_dump_chan_regs as inline
  dw_dmac: fill optional encoded parameters in register structure
  dw_dmac: get number of channels from hardware if possible
  dw_dmac: autoconfigure block_size or use platform data
  dw_dmac: autoconfigure data_width or get it via platform data
  dw_dmac: introduce software emulation of LLP transfers

 arch/arm/mach-spear13xx/spear13xx.c |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c |    3 +
 drivers/dma/dw_dmac.c               |  209 +++++++++++++++++++++++++++++------
 drivers/dma/dw_dmac_regs.h          |   46 ++++++++
 include/linux/dw_dmac.h             |    7 ++
 5 files changed, 235 insertions(+), 33 deletions(-)

-- 
1.7.10.4

