Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2APJvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:17 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:46186 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab2APJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:15 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux@arm.linux.org.uk>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH 0/9] dmaengine: Pl08x and dw_dmac updates
Date: Mon, 16 Jan 2012 15:20:28 +0530
Message-ID: <cover.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod/Dan,

This patchset does following:
- Adds DMA_SLAVE_CONFIG for dw_dmac driver
- Adds device_fc (device flow control) field in struct DMA_SLAVE_CONFIG
- Updates pl08x driver according to that
- Fixes few issues/bugs in dw_dmac driver
- Includes earlier patchset sent by Rajeev for cleanly applying this patchset

Rajeev KUMAR (1):
  dmaengine/dw_dmac: Hibernation support in dw_dmac

Viresh Kumar (7):
  dmaengine: Add flow controller information to dma_slave_config
  dmaengine/amba-pl08x: Take flow controller info from DMA_SLAVE_CONFIG
  dmaengine/dw_dmac: Don't use magic number for total number of
    channels
  dmaengine/dw_dmac: Use platform_get_drvdata instead of accessing dev
    directly
  dmaengine/dw_dmac: Don't handle block interrupts
  dmaengine/dw_dmac: Unmap all memory buffers after completion of slave
    transfers
  dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG

 drivers/dma/amba-pl08x.c   |    4 +-
 drivers/dma/dw_dmac.c      |  171 ++++++++++++++++++++++++++------------------
 drivers/dma/dw_dmac_regs.h |    3 +
 include/linux/amba/pl08x.h |    8 +-
 include/linux/dmaengine.h  |    5 ++
 include/linux/dw_dmac.h    |    6 --
 6 files changed, 115 insertions(+), 82 deletions(-)

-- 
1.7.8.110.g4cb5d

