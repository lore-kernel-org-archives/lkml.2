Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1DSIcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:32:32 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:50944 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab1DSIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:32:30 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 0/7] dmaengine/dw_dmac updates
Date: Tue, 19 Apr 2011 14:02:05 +0530
Message-ID: <cover.1303194835.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes few issues and extends its support.

Changes in V2:
 - lflags added in dw_dma_chan instead of dw_dma
 - Patch from Linus Walleij added for pause and resume functionality.

Linus Walleij (1):
  dmaengine/dw_dmac: implement pause and resume in dwc_control

Viresh Kumar (6):
  dmaengine/dw_dmac: Replace spin_lock_bh with irqsave variants
  dmaengine/dw_dmac: Enable resubmission from callback routine.
  dmaengine/dw_dmac: call dwc_descriptor_complete from dwc_control with
    lock held
  dmaengine/dw_dmac: don't call callback routine in case
    dmaengine_terminate_all() is called
  dmaengine/dw_dmac: set residue as total len in dwc_tx_status if
    status is !DMA_SUCCESS
  dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater
    than DWC_MAX_COUNT

 drivers/dma/dw_dmac.c      |  179 ++++++++++++++++++++++++++++----------------
 drivers/dma/dw_dmac_regs.h |    2 +
 2 files changed, 117 insertions(+), 64 deletions(-)

-- 
1.7.2.2

