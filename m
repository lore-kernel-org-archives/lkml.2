Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab2IDPPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:15:43 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab2IDPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:38 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYThhGCAKd7kmCBIZAMgRIDlVmSf4Ff
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821818"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 06/16] Staging: ipack/devices/ipoctal: ipoctal cleanups.
Date: Tue,  4 Sep 2012 17:01:11 +0200
Message-Id: <1346770881-4723-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Define memory address space, fix sparse warnings and mark the structs
reflecting hardware memory layout "packed" to be on the safe side.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   14 ++---
 drivers/staging/ipack/devices/scc2698.h |   96 +++++++++++++++----------------
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 085b6c0..76f8427 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -40,8 +40,8 @@ struct ipoctal {
 	struct list_head		list;
 	struct ipack_device		*dev;
 	unsigned int			board_id;
-	struct scc2698_channel		*chan_regs;
-	struct scc2698_block		*block_regs;
+	struct scc2698_channel __iomem	*chan_regs;
+	struct scc2698_block __iomem	*block_regs;
 	struct ipoctal_stats		chan_stats[NR_CHANNELS];
 	unsigned int			nb_bytes[NR_CHANNELS];
 	unsigned int			count_wr[NR_CHANNELS];
@@ -59,8 +59,8 @@ struct ipoctal {
 static LIST_HEAD(ipoctal_list);
 
 static inline void ipoctal_write_io_reg(struct ipoctal *ipoctal,
-					unsigned char *dest,
-					unsigned char value)
+					u8 __iomem *dest,
+					u8 value)
 {
 	iowrite8(value, dest);
 }
@@ -73,7 +73,7 @@ static inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal,
 }
 
 static inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal,
-						unsigned char *src)
+						u8 __iomem *src)
 {
 	return ioread8(src);
 }
@@ -391,9 +391,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 	/* Save the virtual address to access the registers easily */
 	ipoctal->chan_regs =
-		(struct scc2698_channel *) ipoctal->dev->io_space.address;
+		(struct scc2698_channel __iomem *) ipoctal->dev->io_space.address;
 	ipoctal->block_regs =
-		(struct scc2698_block *) ipoctal->dev->io_space.address;
+		(struct scc2698_block __iomem *) ipoctal->dev->io_space.address;
 
 	/* Disable RX and TX before touching anything */
 	for (i = 0; i < NR_CHANNELS ; i++) {
diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
index 47f6269..fcab427 100644
--- a/drivers/staging/ipack/devices/scc2698.h
+++ b/drivers/staging/ipack/devices/scc2698.h
@@ -23,21 +23,21 @@
 struct scc2698_channel {
 	union {
 		struct {
-			unsigned char d0, mr;  /* Mode register 1/2*/
-			unsigned char d1, sr;  /* Status register */
-			unsigned char d2, r1;  /* reserved */
-			unsigned char d3, rhr; /* Receive holding register (R) */
-			unsigned char junk[8]; /* other crap for block control */
-		} r; /* Read access */
+			u8 d0, mr;  /* Mode register 1/2*/
+			u8 d1, sr;  /* Status register */
+			u8 d2, r1;  /* reserved */
+			u8 d3, rhr; /* Receive holding register (R) */
+			u8 junk[8]; /* other crap for block control */
+		} __packed r; /* Read access */
 		struct {
-			unsigned char d0, mr;  /* Mode register 1/2 */
-			unsigned char d1, csr; /* Clock select register */
-			unsigned char d2, cr;  /* Command register */
-			unsigned char d3, thr; /* Transmit holding register */
-			unsigned char junk[8]; /* other crap for block control */
-		} w; /* Write access */
+			u8 d0, mr;  /* Mode register 1/2 */
+			u8 d1, csr; /* Clock select register */
+			u8 d2, cr;  /* Command register */
+			u8 d3, thr; /* Transmit holding register */
+			u8 junk[8]; /* other crap for block control */
+		} __packed w; /* Write access */
 	} u;
-};
+} __packed;
 
 /*
  * struct scc2698_block - Block access to scc2698 IO
@@ -50,43 +50,43 @@ struct scc2698_channel {
 struct scc2698_block {
 	union {
 		struct {
-			unsigned char d0, mra;  /* Mode register 1/2 (a) */
-			unsigned char d1, sra;  /* Status register (a) */
-			unsigned char d2, r1;   /* reserved */
-			unsigned char d3, rhra; /* Receive holding register (a) */
-			unsigned char d4, ipcr; /* Input port change register of block */
-			unsigned char d5, isr;  /* Interrupt status register of block */
-			unsigned char d6, ctur; /* Counter timer upper register of block */
-			unsigned char d7, ctlr; /* Counter timer lower register of block */
-			unsigned char d8, mrb;  /* Mode register 1/2 (b) */
-			unsigned char d9, srb;  /* Status register (b) */
-			unsigned char da, r2;   /* reserved */
-			unsigned char db, rhrb; /* Receive holding register (b) */
-			unsigned char dc, r3;   /* reserved */
-			unsigned char dd, ip;   /* Input port register of block */
-			unsigned char de, ctg;  /* Start counter timer of block */
-			unsigned char df, cts;  /* Stop counter timer of block */
-		} r; /* Read access */
+			u8 d0, mra;  /* Mode register 1/2 (a) */
+			u8 d1, sra;  /* Status register (a) */
+			u8 d2, r1;   /* reserved */
+			u8 d3, rhra; /* Receive holding register (a) */
+			u8 d4, ipcr; /* Input port change register of block */
+			u8 d5, isr;  /* Interrupt status register of block */
+			u8 d6, ctur; /* Counter timer upper register of block */
+			u8 d7, ctlr; /* Counter timer lower register of block */
+			u8 d8, mrb;  /* Mode register 1/2 (b) */
+			u8 d9, srb;  /* Status register (b) */
+			u8 da, r2;   /* reserved */
+			u8 db, rhrb; /* Receive holding register (b) */
+			u8 dc, r3;   /* reserved */
+			u8 dd, ip;   /* Input port register of block */
+			u8 de, ctg;  /* Start counter timer of block */
+			u8 df, cts;  /* Stop counter timer of block */
+		} __packed r; /* Read access */
 		struct {
-			unsigned char d0, mra;  /* Mode register 1/2 (a) */
-			unsigned char d1, csra; /* Clock select register (a) */
-			unsigned char d2, cra;  /* Command register (a) */
-			unsigned char d3, thra; /* Transmit holding register (a) */
-			unsigned char d4, acr;  /* Auxiliary control register of block */
-			unsigned char d5, imr;  /* Interrupt mask register of block  */
-			unsigned char d6, ctu;  /* Counter timer upper register of block */
-			unsigned char d7, ctl;  /* Counter timer lower register of block */
-			unsigned char d8, mrb;  /* Mode register 1/2 (b) */
-			unsigned char d9, csrb; /* Clock select register (a) */
-			unsigned char da, crb;  /* Command register (b) */
-			unsigned char db, thrb; /* Transmit holding register (b) */
-			unsigned char dc, r1;   /* reserved */
-			unsigned char dd, opcr; /* Output port configuration register of block */
-			unsigned char de, r2;   /* reserved */
-			unsigned char df, r3;   /* reserved */
-		} w; /* Write access */
+			u8 d0, mra;  /* Mode register 1/2 (a) */
+			u8 d1, csra; /* Clock select register (a) */
+			u8 d2, cra;  /* Command register (a) */
+			u8 d3, thra; /* Transmit holding register (a) */
+			u8 d4, acr;  /* Auxiliary control register of block */
+			u8 d5, imr;  /* Interrupt mask register of block  */
+			u8 d6, ctu;  /* Counter timer upper register of block */
+			u8 d7, ctl;  /* Counter timer lower register of block */
+			u8 d8, mrb;  /* Mode register 1/2 (b) */
+			u8 d9, csrb; /* Clock select register (a) */
+			u8 da, crb;  /* Command register (b) */
+			u8 db, thrb; /* Transmit holding register (b) */
+			u8 dc, r1;   /* reserved */
+			u8 dd, opcr; /* Output port configuration register of block */
+			u8 de, r2;   /* reserved */
+			u8 df, r3;   /* reserved */
+		} __packed w; /* Write access */
 	} u;
-} ;
+} __packed;
 
 #define MR1_CHRL_5_BITS             (0x0 << 0)
 #define MR1_CHRL_6_BITS             (0x1 << 0)
-- 
1.7.10.4

