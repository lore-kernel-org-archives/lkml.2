Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1D0JhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:37:15 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:36165 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564Ab1D0JhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:37:13 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 0/7] dmaengine/dw_dmac updates
Date: Wed, 27 Apr 2011 15:06:42 +0530
Message-ID: <cover.1303896566.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes few issues and extends its support.

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

Viresh Kumar (6):
  dmaengine/dw_dmac: call dwc_descriptor_complete from dwc_control with
    lock held
  dmaengine/dw_dmac: Replace spin_lock* with irqsave variants
  dmaengine/dw_dmac: don't call callback routine in case
    dmaengine_terminate_all() is called
  dmaengine/dw_dmac: Enable resubmission from callback routine.
  dmaengine/dw_dmac: set residue as total len in dwc_tx_status if
    status is !DMA_SUCCESS
  dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater
    than DWC_MAX_COUNT

 drivers/dma/dw_dmac.c      |  260 ++++++++++++++++++++++++++++----------------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 165 insertions(+), 96 deletions(-)

-- 
1.7.3.4

