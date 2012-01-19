Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2ASGPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:15:43 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:1872
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab2ASGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:39 -0500
X-SpamScore: 6
X-BigFish: VS6(z5105h2005kzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 09/10] MTD/GPMI : add a new field `gpmi_version`
Date: Thu, 19 Jan 2012 14:16:06 +0800
Message-ID: <1326953767-24155-10-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add this field to store the GPMI verison.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |    3 +++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |    4 ++++
 drivers/mtd/nand/gpmi-nand/gpmi-regs.h |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 7f68042..5b73ae5 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -133,6 +133,9 @@ int gpmi_init(struct gpmi_nand_data *this)
 	if (ret)
 		goto err_out;
 
+	/* Read out the GPMI version */
+	this->gpmi_version = readl(r->gpmi_regs + HW_GPMI_VERSION);
+
 	/* Choose NAND mode. */
 	writel(BM_GPMI_CTRL1_GPMI_MODE, r->gpmi_regs + HW_GPMI_CTRL1_CLR);
 
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
index 1c7fdbb..5c277e3 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
@@ -132,6 +132,10 @@ struct gpmi_nand_data {
 	/* Flash Hardware */
 	struct nand_timing	timing;
 
+	/* GPMI hardware version */
+#define GPMI_VERSION_0501	(0x05010000)
+	u32			gpmi_version;
+
 	/* BCH */
 	struct bch_geometry	bch_geometry;
 	struct completion	bch_done;
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-regs.h b/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
index 8343124..f005b24 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-regs.h
@@ -169,4 +169,6 @@
 #define HW_GPMI_DEBUG					0x000000c0
 #define MX23_BP_GPMI_DEBUG_READY0			28
 #define MX23_BM_GPMI_DEBUG_READY0	(1 << MX23_BP_GPMI_DEBUG_READY0)
+
+#define HW_GPMI_VERSION					0x000000d0
 #endif
-- 
1.7.0.4


