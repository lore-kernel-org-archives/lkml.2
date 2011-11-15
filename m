Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1KOKnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:43:50 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:36574
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980Ab1KOKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:43:48 -0500
X-SpamScore: -5
X-BigFish: VS-5(zz1803Mzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: <b35362@freescale.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>
CC: <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <scottwood@freescale.com>,
        Liu Shuo <b35362@freescale.com>
Subject: [PATCH 1/3] mtd/nand: fix coding style issue in drivers/mtd/nand/fsl_elbc.c
Date: Tue, 15 Nov 2011 17:29:13 +0800
Message-ID: <1321349355-1639-1-git-send-email-b35362@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Shuo <b35362@freescale.com>

fix whitespaces,tabs coding style issue and use #include <linux/io.h> instead of <asm/io.h>
in drivers/mtd/nand/fsl_elbc.c.

Signed-off-by: Liu Shuo <b35362@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/mtd/nand/fsl_elbc_nand.c |  194 +++++++++++++++++++-------------------
 1 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index eedd8ee..1bfcdef 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -38,7 +38,7 @@
 #include <linux/mtd/nand_ecc.h>
 #include <linux/mtd/partitions.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/fsl_lbc.h>
 
 #define MAX_BANKS 8
@@ -167,17 +167,17 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 	elbc_fcm_ctrl->page = page_addr;
 
 	out_be32(&lbc->fbar,
-	         page_addr >> (chip->phys_erase_shift - chip->page_shift));
+		 page_addr >> (chip->phys_erase_shift - chip->page_shift));
 
 	if (priv->page_size) {
 		out_be32(&lbc->fpar,
-		         ((page_addr << FPAR_LP_PI_SHIFT) & FPAR_LP_PI) |
-		         (oob ? FPAR_LP_MS : 0) | column);
+			 ((page_addr << FPAR_LP_PI_SHIFT) & FPAR_LP_PI) |
+			 (oob ? FPAR_LP_MS : 0) | column);
 		buf_num = (page_addr & 1) << 2;
 	} else {
 		out_be32(&lbc->fpar,
-		         ((page_addr << FPAR_SP_PI_SHIFT) & FPAR_SP_PI) |
-		         (oob ? FPAR_SP_MS : 0) | column);
+			 ((page_addr << FPAR_SP_PI_SHIFT) & FPAR_SP_PI) |
+			 (oob ? FPAR_SP_MS : 0) | column);
 		buf_num = page_addr & 7;
 	}
 
@@ -190,10 +190,10 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	dev_vdbg(priv->dev, "set_addr: bank=%d, "
 			    "elbc_fcm_ctrl->addr=0x%p (0x%p), "
-	                    "index %x, pes %d ps %d\n",
+			    "index %x, pes %d ps %d\n",
 		 buf_num, elbc_fcm_ctrl->addr, priv->vbase,
 		 elbc_fcm_ctrl->index,
-	         chip->phys_erase_shift, chip->page_shift);
+		 chip->phys_erase_shift, chip->page_shift);
 }
 
 /*
@@ -213,13 +213,13 @@ static int fsl_elbc_run_command(struct mtd_info *mtd)
 		out_be32(&lbc->mdr, elbc_fcm_ctrl->mdr);
 
 	dev_vdbg(priv->dev,
-	         "fsl_elbc_run_command: fmr=%08x fir=%08x fcr=%08x\n",
-	         in_be32(&lbc->fmr), in_be32(&lbc->fir), in_be32(&lbc->fcr));
+		 "fsl_elbc_run_command: fmr=%08x fir=%08x fcr=%08x\n",
+		 in_be32(&lbc->fmr), in_be32(&lbc->fir), in_be32(&lbc->fcr));
 	dev_vdbg(priv->dev,
-	         "fsl_elbc_run_command: fbar=%08x fpar=%08x "
-	         "fbcr=%08x bank=%d\n",
-	         in_be32(&lbc->fbar), in_be32(&lbc->fpar),
-	         in_be32(&lbc->fbcr), priv->bank);
+		 "fsl_elbc_run_command: fbar=%08x fpar=%08x "
+		 "fbcr=%08x bank=%d\n",
+		 in_be32(&lbc->fbar), in_be32(&lbc->fpar),
+		 in_be32(&lbc->fbcr), priv->bank);
 
 	ctrl->irq_status = 0;
 	/* execute special operation */
@@ -227,7 +227,7 @@ static int fsl_elbc_run_command(struct mtd_info *mtd)
 
 	/* wait for FCM complete flag or timeout */
 	wait_event_timeout(ctrl->irq_wait, ctrl->irq_status,
-	                   FCM_TIMEOUT_MSECS * HZ/1000);
+			   FCM_TIMEOUT_MSECS * HZ/1000);
 	elbc_fcm_ctrl->status = ctrl->irq_status;
 	/* store mdr value in case it was needed */
 	if (elbc_fcm_ctrl->use_mdr)
@@ -237,8 +237,8 @@ static int fsl_elbc_run_command(struct mtd_info *mtd)
 
 	if (elbc_fcm_ctrl->status != LTESR_CC) {
 		dev_info(priv->dev,
-		         "command failed: fir %x fcr %x status %x mdr %x\n",
-		         in_be32(&lbc->fir), in_be32(&lbc->fcr),
+			 "command failed: fir %x fcr %x status %x mdr %x\n",
+			 in_be32(&lbc->fir), in_be32(&lbc->fcr),
 			 elbc_fcm_ctrl->status, elbc_fcm_ctrl->mdr);
 		return -EIO;
 	}
@@ -273,20 +273,20 @@ static void fsl_elbc_do_read(struct nand_chip *chip, int oob)
 
 	if (priv->page_size) {
 		out_be32(&lbc->fir,
-		         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-		         (FIR_OP_CA  << FIR_OP1_SHIFT) |
-		         (FIR_OP_PA  << FIR_OP2_SHIFT) |
-		         (FIR_OP_CM1 << FIR_OP3_SHIFT) |
-		         (FIR_OP_RBW << FIR_OP4_SHIFT));
+			 (FIR_OP_CM0 << FIR_OP0_SHIFT) |
+			 (FIR_OP_CA  << FIR_OP1_SHIFT) |
+			 (FIR_OP_PA  << FIR_OP2_SHIFT) |
+			 (FIR_OP_CM1 << FIR_OP3_SHIFT) |
+			 (FIR_OP_RBW << FIR_OP4_SHIFT));
 
 		out_be32(&lbc->fcr, (NAND_CMD_READ0 << FCR_CMD0_SHIFT) |
-		                    (NAND_CMD_READSTART << FCR_CMD1_SHIFT));
+				    (NAND_CMD_READSTART << FCR_CMD1_SHIFT));
 	} else {
 		out_be32(&lbc->fir,
-		         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-		         (FIR_OP_CA  << FIR_OP1_SHIFT) |
-		         (FIR_OP_PA  << FIR_OP2_SHIFT) |
-		         (FIR_OP_RBW << FIR_OP3_SHIFT));
+			 (FIR_OP_CM0 << FIR_OP0_SHIFT) |
+			 (FIR_OP_CA  << FIR_OP1_SHIFT) |
+			 (FIR_OP_PA  << FIR_OP2_SHIFT) |
+			 (FIR_OP_RBW << FIR_OP3_SHIFT));
 
 		if (oob)
 			out_be32(&lbc->fcr, NAND_CMD_READOOB << FCR_CMD0_SHIFT);
@@ -297,7 +297,7 @@ static void fsl_elbc_do_read(struct nand_chip *chip, int oob)
 
 /* cmdfunc send commands to the FCM */
 static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
-                             int column, int page_addr)
+				int column, int page_addr)
 {
 	struct nand_chip *chip = mtd->priv;
 	struct fsl_elbc_mtd *priv = chip->priv;
@@ -320,8 +320,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* fall-through */
 	case NAND_CMD_READ0:
 		dev_dbg(priv->dev,
-		        "fsl_elbc_cmdfunc: NAND_CMD_READ0, page_addr:"
-		        " 0x%x, column: 0x%x.\n", page_addr, column);
+			"fsl_elbc_cmdfunc: NAND_CMD_READ0, page_addr:"
+			" 0x%x, column: 0x%x.\n", page_addr, column);
 
 
 		out_be32(&lbc->fbcr, 0); /* read entire page to enable ECC */
@@ -337,7 +337,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* READOOB reads only the OOB because no ECC is performed. */
 	case NAND_CMD_READOOB:
 		dev_vdbg(priv->dev,
-		         "fsl_elbc_cmdfunc: NAND_CMD_READOOB, page_addr:"
+			 "fsl_elbc_cmdfunc: NAND_CMD_READOOB, page_addr:"
 			 " 0x%x, column: 0x%x.\n", page_addr, column);
 
 		out_be32(&lbc->fbcr, mtd->oobsize - column);
@@ -354,8 +354,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		dev_vdbg(priv->dev, "fsl_elbc_cmdfunc: NAND_CMD_READID.\n");
 
 		out_be32(&lbc->fir, (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-		                    (FIR_OP_UA  << FIR_OP1_SHIFT) |
-		                    (FIR_OP_RBW << FIR_OP2_SHIFT));
+				    (FIR_OP_UA  << FIR_OP1_SHIFT) |
+				    (FIR_OP_RBW << FIR_OP2_SHIFT));
 		out_be32(&lbc->fcr, NAND_CMD_READID << FCR_CMD0_SHIFT);
 		/* nand_get_flash_type() reads 8 bytes of entire ID string */
 		out_be32(&lbc->fbcr, 8);
@@ -370,8 +370,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* ERASE1 stores the block and page address */
 	case NAND_CMD_ERASE1:
 		dev_vdbg(priv->dev,
-		         "fsl_elbc_cmdfunc: NAND_CMD_ERASE1, "
-		         "page_addr: 0x%x.\n", page_addr);
+			 "fsl_elbc_cmdfunc: NAND_CMD_ERASE1, "
+			 "page_addr: 0x%x.\n", page_addr);
 		set_addr(mtd, 0, page_addr, 0);
 		return;
 
@@ -380,16 +380,16 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		dev_vdbg(priv->dev, "fsl_elbc_cmdfunc: NAND_CMD_ERASE2.\n");
 
 		out_be32(&lbc->fir,
-		         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-		         (FIR_OP_PA  << FIR_OP1_SHIFT) |
-		         (FIR_OP_CM2 << FIR_OP2_SHIFT) |
-		         (FIR_OP_CW1 << FIR_OP3_SHIFT) |
-		         (FIR_OP_RS  << FIR_OP4_SHIFT));
+			 (FIR_OP_CM0 << FIR_OP0_SHIFT) |
+			 (FIR_OP_PA  << FIR_OP1_SHIFT) |
+			 (FIR_OP_CM2 << FIR_OP2_SHIFT) |
+			 (FIR_OP_CW1 << FIR_OP3_SHIFT) |
+			 (FIR_OP_RS  << FIR_OP4_SHIFT));
 
 		out_be32(&lbc->fcr,
-		         (NAND_CMD_ERASE1 << FCR_CMD0_SHIFT) |
-		         (NAND_CMD_STATUS << FCR_CMD1_SHIFT) |
-		         (NAND_CMD_ERASE2 << FCR_CMD2_SHIFT));
+			 (NAND_CMD_ERASE1 << FCR_CMD0_SHIFT) |
+			 (NAND_CMD_STATUS << FCR_CMD1_SHIFT) |
+			 (NAND_CMD_ERASE2 << FCR_CMD2_SHIFT));
 
 		out_be32(&lbc->fbcr, 0);
 		elbc_fcm_ctrl->read_bytes = 0;
@@ -403,8 +403,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		__be32 fcr;
 		dev_vdbg(priv->dev,
 			 "fsl_elbc_cmdfunc: NAND_CMD_SEQIN/PAGE_PROG, "
-		         "page_addr: 0x%x, column: 0x%x.\n",
-		         page_addr, column);
+			 "page_addr: 0x%x, column: 0x%x.\n",
+			 page_addr, column);
 
 		elbc_fcm_ctrl->column = column;
 		elbc_fcm_ctrl->oob = 0;
@@ -416,23 +416,23 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 		if (priv->page_size) {
 			out_be32(&lbc->fir,
-			         (FIR_OP_CM2 << FIR_OP0_SHIFT) |
-			         (FIR_OP_CA  << FIR_OP1_SHIFT) |
-			         (FIR_OP_PA  << FIR_OP2_SHIFT) |
-			         (FIR_OP_WB  << FIR_OP3_SHIFT) |
-			         (FIR_OP_CM3 << FIR_OP4_SHIFT) |
-			         (FIR_OP_CW1 << FIR_OP5_SHIFT) |
-			         (FIR_OP_RS  << FIR_OP6_SHIFT));
+				 (FIR_OP_CM2 << FIR_OP0_SHIFT) |
+				 (FIR_OP_CA  << FIR_OP1_SHIFT) |
+				 (FIR_OP_PA  << FIR_OP2_SHIFT) |
+				 (FIR_OP_WB  << FIR_OP3_SHIFT) |
+				 (FIR_OP_CM3 << FIR_OP4_SHIFT) |
+				 (FIR_OP_CW1 << FIR_OP5_SHIFT) |
+				 (FIR_OP_RS  << FIR_OP6_SHIFT));
 		} else {
 			out_be32(&lbc->fir,
-			         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-			         (FIR_OP_CM2 << FIR_OP1_SHIFT) |
-			         (FIR_OP_CA  << FIR_OP2_SHIFT) |
-			         (FIR_OP_PA  << FIR_OP3_SHIFT) |
-			         (FIR_OP_WB  << FIR_OP4_SHIFT) |
-			         (FIR_OP_CM3 << FIR_OP5_SHIFT) |
-			         (FIR_OP_CW1 << FIR_OP6_SHIFT) |
-			         (FIR_OP_RS  << FIR_OP7_SHIFT));
+				 (FIR_OP_CM0 << FIR_OP0_SHIFT) |
+				 (FIR_OP_CM2 << FIR_OP1_SHIFT) |
+				 (FIR_OP_CA  << FIR_OP2_SHIFT) |
+				 (FIR_OP_PA  << FIR_OP3_SHIFT) |
+				 (FIR_OP_WB  << FIR_OP4_SHIFT) |
+				 (FIR_OP_CM3 << FIR_OP5_SHIFT) |
+				 (FIR_OP_CW1 << FIR_OP6_SHIFT) |
+				 (FIR_OP_RS  << FIR_OP7_SHIFT));
 
 			if (column >= mtd->writesize) {
 				/* OOB area --> READOOB */
@@ -454,7 +454,7 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* PAGEPROG reuses all of the setup from SEQIN and adds the length */
 	case NAND_CMD_PAGEPROG: {
 		dev_vdbg(priv->dev,
-		         "fsl_elbc_cmdfunc: NAND_CMD_PAGEPROG "
+			 "fsl_elbc_cmdfunc: NAND_CMD_PAGEPROG "
 			 "writing %d bytes.\n", elbc_fcm_ctrl->index);
 
 		/* if the write did not start at 0 or is not a full page
@@ -475,8 +475,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* Note - it does not wait for the ready line */
 	case NAND_CMD_STATUS:
 		out_be32(&lbc->fir,
-		         (FIR_OP_CM0 << FIR_OP0_SHIFT) |
-		         (FIR_OP_RBW << FIR_OP1_SHIFT));
+			 (FIR_OP_CM0 << FIR_OP0_SHIFT) |
+			 (FIR_OP_RBW << FIR_OP1_SHIFT));
 		out_be32(&lbc->fcr, NAND_CMD_STATUS << FCR_CMD0_SHIFT);
 		out_be32(&lbc->fbcr, 1);
 		set_addr(mtd, 0, 0, 0);
@@ -500,8 +500,8 @@ static void fsl_elbc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 	default:
 		dev_err(priv->dev,
-		        "fsl_elbc_cmdfunc: error, unsupported command 0x%x.\n",
-		        command);
+			"fsl_elbc_cmdfunc: error, unsupported command 0x%x.\n",
+			command);
 	}
 }
 
@@ -530,8 +530,8 @@ static void fsl_elbc_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 
 	if ((unsigned int)len > bufsize - elbc_fcm_ctrl->index) {
 		dev_err(priv->dev,
-		        "write_buf beyond end of buffer "
-		        "(%d requested, %u available)\n",
+			"write_buf beyond end of buffer "
+			"(%d requested, %u available)\n",
 			len, bufsize - elbc_fcm_ctrl->index);
 		len = bufsize - elbc_fcm_ctrl->index;
 	}
@@ -587,9 +587,9 @@ static void fsl_elbc_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 
 	if (len > avail)
 		dev_err(priv->dev,
-		        "read_buf beyond end of buffer "
-		        "(%d requested, %d available)\n",
-		        len, avail);
+			"read_buf beyond end of buffer "
+			"(%d requested, %d available)\n",
+			len, avail);
 }
 
 /*
@@ -661,44 +661,44 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 
 	/* add to ECCM mode set in fsl_elbc_init */
 	priv->fmr |= (12 << FMR_CWTO_SHIFT) |  /* Timeout > 12 ms */
-	             (al << FMR_AL_SHIFT);
+		     (al << FMR_AL_SHIFT);
 
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->numchips = %d\n",
-	        chip->numchips);
+		chip->numchips);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->chipsize = %lld\n",
-	        chip->chipsize);
+		chip->chipsize);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->pagemask = %8x\n",
-	        chip->pagemask);
+		chip->pagemask);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->chip_delay = %d\n",
-	        chip->chip_delay);
+		chip->chip_delay);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->badblockpos = %d\n",
-	        chip->badblockpos);
+		chip->badblockpos);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->chip_shift = %d\n",
-	        chip->chip_shift);
+		chip->chip_shift);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->page_shift = %d\n",
-	        chip->page_shift);
+		chip->page_shift);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->phys_erase_shift = %d\n",
-	        chip->phys_erase_shift);
+		chip->phys_erase_shift);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecclayout = %p\n",
-	        chip->ecclayout);
+		chip->ecclayout);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.mode = %d\n",
-	        chip->ecc.mode);
+		chip->ecc.mode);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.steps = %d\n",
-	        chip->ecc.steps);
+		chip->ecc.steps);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.bytes = %d\n",
-	        chip->ecc.bytes);
+		chip->ecc.bytes);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.total = %d\n",
-	        chip->ecc.total);
+		chip->ecc.total);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.layout = %p\n",
-	        chip->ecc.layout);
+		chip->ecc.layout);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->flags = %08x\n", mtd->flags);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->size = %lld\n", mtd->size);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->erasesize = %d\n",
-	        mtd->erasesize);
+		mtd->erasesize);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->writesize = %d\n",
-	        mtd->writesize);
+		mtd->writesize);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->oobsize = %d\n",
-	        mtd->oobsize);
+		mtd->oobsize);
 
 	/* adjust Option Register and ECC to match Flash page size */
 	if (mtd->writesize == 512) {
@@ -712,14 +712,14 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 		    BR_DECC_CHK_GEN) {
 			chip->ecc.size = 512;
 			chip->ecc.layout = (priv->fmr & FMR_ECCM) ?
-			                   &fsl_elbc_oob_lp_eccm1 :
-			                   &fsl_elbc_oob_lp_eccm0;
+					   &fsl_elbc_oob_lp_eccm1 :
+					   &fsl_elbc_oob_lp_eccm0;
 			chip->badblock_pattern = &largepage_memorybased;
 		}
 	} else {
 		dev_err(priv->dev,
-		        "fsl_elbc_init: page size %d is not supported\n",
-		        mtd->writesize);
+			"fsl_elbc_init: page size %d is not supported\n",
+			mtd->writesize);
 		return -1;
 	}
 
@@ -727,9 +727,9 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 }
 
 static int fsl_elbc_read_page(struct mtd_info *mtd,
-                              struct nand_chip *chip,
-			      uint8_t *buf,
-			      int page)
+				struct nand_chip *chip,
+				uint8_t *buf,
+				int page)
 {
 	fsl_elbc_read_buf(mtd, buf, mtd->writesize);
 	fsl_elbc_read_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -744,8 +744,8 @@ static int fsl_elbc_read_page(struct mtd_info *mtd,
  * waitfunc.
  */
 static void fsl_elbc_write_page(struct mtd_info *mtd,
-                                struct nand_chip *chip,
-                                const uint8_t *buf)
+				 struct nand_chip *chip,
+				 const uint8_t *buf)
 {
 	fsl_elbc_write_buf(mtd, buf, mtd->writesize);
 	fsl_elbc_write_buf(mtd, chip->oob_poi, mtd->oobsize);
-- 
1.7.1


