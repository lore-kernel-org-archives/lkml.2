Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2IJGZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:25:05 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:28039
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706Ab2IJGZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:25:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzzz1202h1d1ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <mikedunn@newsguy.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/2] mtd: add helpers to get the supportted ONFI timing mode
Date: Mon, 10 Sep 2012 14:01:11 +0800
Message-ID: <1347256871-18339-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1347256871-18339-1-git-send-email-b32955@freescale.com>
References: <1347256871-18339-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add onfi_get_async_timing_mode() to get the supportted asynchronous
timing mode.

add onfi_get_sync_timing_mode() to get the supportted synchronous
timing mode.

Also add the neccessary macros : the timing modes.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 641794c..83b85a1 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -231,6 +231,14 @@ typedef enum {
 /* Keep gcc happy */
 struct nand_chip;
 
+/* ONFI timing mode, used in both asynchronous and synchronous mode */
+#define ONFI_TIMING_MODE_0	(1 << 0)
+#define ONFI_TIMING_MODE_1	(1 << 1)
+#define ONFI_TIMING_MODE_2	(1 << 2)
+#define ONFI_TIMING_MODE_3	(1 << 3)
+#define ONFI_TIMING_MODE_4	(1 << 4)
+#define ONFI_TIMING_MODE_5	(1 << 5)
+
 /* ONFI feature address */
 #define ONFI_FEATURE_ADDR_TIMING_MODE	0x1
 
@@ -682,4 +690,16 @@ struct platform_nand_chip *get_platform_nandchip(struct mtd_info *mtd)
 	return chip->priv;
 }
 
+/* return the supported asynchronous timing mode. */
+static inline int onfi_get_async_timing_mode(struct nand_chip *chip)
+{
+	return le16_to_cpu(chip->onfi_params.async_timing_mode);
+}
+
+/* return the supported synchronous timing mode. */
+static inline int onfi_get_sync_timing_mode(struct nand_chip *chip)
+{
+	return le16_to_cpu(chip->onfi_params.src_sync_timing_mode);
+}
+
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.7.0.4


