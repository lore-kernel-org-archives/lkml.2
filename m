Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1CCKSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:18:13 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49369 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1CCKSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:18:12 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <jamie@jamieiles.com>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>,
        <hans-christian.egtvedt@atmel.com>
Subject: [PATCH V2 01/13] dw_dmac: Remove compilation dependency from AVR32 and put on HAVE_CLK
Date: Thu, 3 Mar 2011 15:47:14 +0530
Message-ID: <25131616c787e711b89733b4098cde7207b696de.1299146382.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1299146382.git.viresh.kumar@st.com>
References: <cover.1299146382.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will now be used in atleast two platforms AVR32 & ARM. And there is
no actual hardware dependency of this driver over AVR32 or ARM. So this
dependency can be removed altogether.

Also dw_dmac driver uses clk framework and must have compilation dependency on
HAVE_CLK

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1c28816..3822fe1 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -82,7 +82,7 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
-	depends on AVR32
+	depends on HAVE_CLK
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
-- 
1.7.2.2

