Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2ETWxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 18:53:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33517 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756848Ab2ETWxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 18:53:46 -0400
Message-ID: <1337553915.31503.12.camel@joe2Laptop>
Subject: [PATCH] media: Use pr_info not homegrown pr_reg macro
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 May 2012 15:45:15 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to duplicate normal kernel logging capabilities.

Add pr_fmt and convert pr_reg to pr_info.
Remove pr_reg macros.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/rc/fintek-cir.c  |   32 +++++----
 drivers/media/rc/nuvoton-cir.c |  145 ++++++++++++++++++++--------------------
 2 files changed, 90 insertions(+), 87 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 4a3a238..01764a3 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -23,6 +23,8 @@
  * USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pnp.h>
@@ -110,30 +112,32 @@ static u8 fintek_cir_reg_read(struct fintek_dev *fintek, u8 offset)
 	return val;
 }
 
-#define pr_reg(text, ...) \
-	printk(KERN_INFO KBUILD_MODNAME ": " text, ## __VA_ARGS__)
-
 /* dump current cir register contents */
 static void cir_dump_regs(struct fintek_dev *fintek)
 {
 	fintek_config_mode_enable(fintek);
 	fintek_select_logical_dev(fintek, fintek->logical_dev_cir);
 
-	pr_reg("%s: Dump CIR logical device registers:\n", FINTEK_DRIVER_NAME);
-	pr_reg(" * CR CIR BASE ADDR: 0x%x\n",
-	       (fintek_cr_read(fintek, CIR_CR_BASE_ADDR_HI) << 8) |
+	pr_info("%s: Dump CIR logical device registers:\n", FINTEK_DRIVER_NAME);
+	pr_info(" * CR CIR BASE ADDR: 0x%x\n",
+		(fintek_cr_read(fintek, CIR_CR_BASE_ADDR_HI) << 8) |
 		fintek_cr_read(fintek, CIR_CR_BASE_ADDR_LO));
-	pr_reg(" * CR CIR IRQ NUM:   0x%x\n",
-	       fintek_cr_read(fintek, CIR_CR_IRQ_SEL));
+	pr_info(" * CR CIR IRQ NUM:   0x%x\n",
+		fintek_cr_read(fintek, CIR_CR_IRQ_SEL));
 
 	fintek_config_mode_disable(fintek);
 
-	pr_reg("%s: Dump CIR registers:\n", FINTEK_DRIVER_NAME);
-	pr_reg(" * STATUS:     0x%x\n", fintek_cir_reg_read(fintek, CIR_STATUS));
-	pr_reg(" * CONTROL:    0x%x\n", fintek_cir_reg_read(fintek, CIR_CONTROL));
-	pr_reg(" * RX_DATA:    0x%x\n", fintek_cir_reg_read(fintek, CIR_RX_DATA));
-	pr_reg(" * TX_CONTROL: 0x%x\n", fintek_cir_reg_read(fintek, CIR_TX_CONTROL));
-	pr_reg(" * TX_DATA:    0x%x\n", fintek_cir_reg_read(fintek, CIR_TX_DATA));
+	pr_info("%s: Dump CIR registers:\n", FINTEK_DRIVER_NAME);
+	pr_info(" * STATUS:     0x%x\n",
+		fintek_cir_reg_read(fintek, CIR_STATUS));
+	pr_info(" * CONTROL:    0x%x\n",
+		fintek_cir_reg_read(fintek, CIR_CONTROL));
+	pr_info(" * RX_DATA:    0x%x\n",
+		fintek_cir_reg_read(fintek, CIR_RX_DATA));
+	pr_info(" * TX_CONTROL: 0x%x\n",
+		fintek_cir_reg_read(fintek, CIR_TX_CONTROL));
+	pr_info(" * TX_DATA:    0x%x\n",
+		fintek_cir_reg_read(fintek, CIR_TX_DATA));
 }
 
 /* detect hardware features */
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 8b2c071..f7b064f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -25,6 +25,8 @@
  * USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pnp.h>
@@ -123,43 +125,40 @@ static u8 nvt_cir_wake_reg_read(struct nvt_dev *nvt, u8 offset)
 	return val;
 }
 
-#define pr_reg(text, ...) \
-	printk(KERN_INFO KBUILD_MODNAME ": " text, ## __VA_ARGS__)
-
 /* dump current cir register contents */
 static void cir_dump_regs(struct nvt_dev *nvt)
 {
 	nvt_efm_enable(nvt);
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
 
-	pr_reg("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);
-	pr_reg(" * CR CIR ACTIVE :   0x%x\n",
-	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
-	pr_reg(" * CR CIR BASE ADDR: 0x%x\n",
-	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
+	pr_info("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);
+	pr_info(" * CR CIR ACTIVE :   0x%x\n",
+		nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
+	pr_info(" * CR CIR BASE ADDR: 0x%x\n",
+		(nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
 		nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
-	pr_reg(" * CR CIR IRQ NUM:   0x%x\n",
-	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
+	pr_info(" * CR CIR IRQ NUM:   0x%x\n",
+		nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
 
 	nvt_efm_disable(nvt);
 
-	pr_reg("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);
-	pr_reg(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));
-	pr_reg(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));
-	pr_reg(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));
-	pr_reg(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));
-	pr_reg(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));
-	pr_reg(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));
-	pr_reg(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));
-	pr_reg(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));
-	pr_reg(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));
-	pr_reg(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));
-	pr_reg(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));
-	pr_reg(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));
-	pr_reg(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));
-	pr_reg(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));
-	pr_reg(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));
-	pr_reg(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));
+	pr_info("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);
+	pr_info(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));
+	pr_info(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));
+	pr_info(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));
+	pr_info(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));
+	pr_info(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));
+	pr_info(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));
+	pr_info(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));
+	pr_info(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));
+	pr_info(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));
+	pr_info(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));
+	pr_info(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));
+	pr_info(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));
+	pr_info(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));
+	pr_info(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));
+	pr_info(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));
+	pr_info(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));
 }
 
 /* dump current cir wake register contents */
@@ -170,59 +169,59 @@ static void cir_wake_dump_regs(struct nvt_dev *nvt)
 	nvt_efm_enable(nvt);
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
 
-	pr_reg("%s: Dump CIR WAKE logical device registers:\n",
-	       NVT_DRIVER_NAME);
-	pr_reg(" * CR CIR WAKE ACTIVE :   0x%x\n",
-	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
-	pr_reg(" * CR CIR WAKE BASE ADDR: 0x%x\n",
-	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
+	pr_info("%s: Dump CIR WAKE logical device registers:\n",
+		NVT_DRIVER_NAME);
+	pr_info(" * CR CIR WAKE ACTIVE :   0x%x\n",
+		nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
+	pr_info(" * CR CIR WAKE BASE ADDR: 0x%x\n",
+		(nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
 		nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
-	pr_reg(" * CR CIR WAKE IRQ NUM:   0x%x\n",
-	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
+	pr_info(" * CR CIR WAKE IRQ NUM:   0x%x\n",
+		nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
 
 	nvt_efm_disable(nvt);
 
-	pr_reg("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);
-	pr_reg(" * IRCON:          0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON));
-	pr_reg(" * IRSTS:          0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS));
-	pr_reg(" * IREN:           0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN));
-	pr_reg(" * FIFO CMP DEEP:  0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_DEEP));
-	pr_reg(" * FIFO CMP TOL:   0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_TOL));
-	pr_reg(" * FIFO COUNT:     0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT));
-	pr_reg(" * SLCH:           0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCH));
-	pr_reg(" * SLCL:           0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCL));
-	pr_reg(" * FIFOCON:        0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON));
-	pr_reg(" * SRXFSTS:        0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SRXFSTS));
-	pr_reg(" * SAMPLE RX FIFO: 0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SAMPLE_RX_FIFO));
-	pr_reg(" * WR FIFO DATA:   0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_WR_FIFO_DATA));
-	pr_reg(" * RD FIFO ONLY:   0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
-	pr_reg(" * RD FIFO ONLY IDX: 0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX));
-	pr_reg(" * FIFO IGNORE:    0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_IGNORE));
-	pr_reg(" * IRFSM:          0x%x\n",
-	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRFSM));
+	pr_info("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);
+	pr_info(" * IRCON:          0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON));
+	pr_info(" * IRSTS:          0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS));
+	pr_info(" * IREN:           0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN));
+	pr_info(" * FIFO CMP DEEP:  0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_DEEP));
+	pr_info(" * FIFO CMP TOL:   0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_TOL));
+	pr_info(" * FIFO COUNT:     0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT));
+	pr_info(" * SLCH:           0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCH));
+	pr_info(" * SLCL:           0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCL));
+	pr_info(" * FIFOCON:        0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON));
+	pr_info(" * SRXFSTS:        0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_SRXFSTS));
+	pr_info(" * SAMPLE RX FIFO: 0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_SAMPLE_RX_FIFO));
+	pr_info(" * WR FIFO DATA:   0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_WR_FIFO_DATA));
+	pr_info(" * RD FIFO ONLY:   0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
+	pr_info(" * RD FIFO ONLY IDX: 0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX));
+	pr_info(" * FIFO IGNORE:    0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_IGNORE));
+	pr_info(" * IRFSM:          0x%x\n",
+		nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRFSM));
 
 	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
-	pr_reg("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);
-	pr_reg("* Contents = ");
+	pr_info("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);
+	pr_info("* Contents =");
 	for (i = 0; i < fifo_len; i++)
-		printk(KERN_CONT "%02x ",
-		       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
-	printk(KERN_CONT "\n");
+		pr_cont(" %02x",
+			nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
+	pr_cont("\n");
 }
 
 /* detect hardware features */


