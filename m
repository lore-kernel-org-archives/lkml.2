Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1DZFi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:38:26 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:47944 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab1DZFiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:38:25 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 resend 0/7] dmaengine/dw_dmac updates
Date: Tue, 26 Apr 2011 11:08:08 +0530
Message-ID: <cover.1303796005.git.viresh.kumar@st.com>
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

 drivers/dma/dw_dmac.c      |  205 +++++++++++++++++++++++++++-----------------
 drivers/dma/dw_dmac_regs.h |    2 +
 2 files changed, 129 insertions(+), 78 deletions(-)

-- 
1.7.2.2

