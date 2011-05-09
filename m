Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1EIIQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:16:16 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:40813 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab1EIIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:16:14 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V5 0/5] dmaengine/dw_dmac updates
Date: Mon, 9 May 2011 13:45:48 +0530
Message-ID: <cover.1304928776.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes few issues and extends its support.

Changes in V5:
 - [PATCH 1/5] rearranging code in dmaengine/dw_dmac: don't call callback
   routine in case dmaengine_terminate_all() is called

Changes in V4:
 - spin_locks are not taken anymore from parent routines. Now every routine
   takes locks whenever required.
 - 1 and 0 are replaced with true and false for bool parameters to routines.
 - flags are not used uninitialized for spin_lock_irqsave

Changes in V3:
 - lflags is removed from dw_dma_chan and local flag variables are created.
 - An extra argument is added to routines calling dwc_descriptor_complete()
   directly or indirectly
 - spin_lock() in tasklet is also changed to irqsave variants.

Changes in V2:
 - lflags added in dw_dma_chan instead of dw_dma
 - Patch from Linus Walleij added for pause and resume functionality.

Linus Walleij (1):
  dmaengine/dw_dmac: implement pause and resume in dwc_control

Viresh Kumar (4):
  dmaengine/dw_dmac: don't call callback routine in case
    dmaengine_terminate_all() is called
  dmaengine/dw_dmac: set residue as total len in dwc_tx_status if
    status is !DMA_SUCCESS
  dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater
    than DWC_MAX_COUNT
  dmaengine/dw_dmac: Replace spin_lock* with irqsave variants and
    enable submission from callback

 drivers/dma/dw_dmac.c      |  267 +++++++++++++++++++++++++++++---------------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 176 insertions(+), 92 deletions(-)

-- 
1.7.2.2

