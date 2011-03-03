Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1CCKS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:59 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:58485 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758052Ab1CCKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:54 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 13/13] avr32: at32ap700x: Specify DMA Flow Controller, Src and Dst msize
Date: Thu, 3 Mar 2011 15:47:26 +0530
Message-ID: <d1d3c68555f13a9f7c1d4919e2b819aba5075a31.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the dw_dmac DMA driver supports configurable Flow Controller, source
and destination burst or msize, we need to specify which ones to use. Msize or
burst size was previously hardcoded to 1, Flow controller was DMA for both
M2P & P2M transfers.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 2747cde..b4aaebd 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -2050,6 +2050,9 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		rx_dws->src_master = 0;
 		rx_dws->dst_master = 1;
+		rx_dws->src_msize = DW_DMA_MSIZE_1;
+		rx_dws->dst_msize = DW_DMA_MSIZE_1;
+		rx_dws->fc = DW_DMA_FC_D_P2M;
 	}
 
 	/* Check if DMA slave interface for playback should be configured. */
@@ -2060,6 +2063,9 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		rx_dws->src_master = 0;
 		rx_dws->dst_master = 1;
+		tx_dws->src_msize = DW_DMA_MSIZE_1;
+		tx_dws->dst_msize = DW_DMA_MSIZE_1;
+		tx_dws->fc = DW_DMA_FC_D_M2P;
 	}
 
 	if (platform_device_add_data(pdev, data,
@@ -2134,6 +2140,9 @@ at32_add_device_abdac(unsigned int id, struct atmel_abdac_pdata *data)
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 	dws->src_master = 0;
 	dws->dst_master = 1;
+	dws->src_msize = DW_DMA_MSIZE_1;
+	dws->dst_msize = DW_DMA_MSIZE_1;
+	dws->fc = DW_DMA_FC_D_M2P;
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct atmel_abdac_pdata)))
-- 
1.7.2.2

