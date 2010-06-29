Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0F2KPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0F2KPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wNHtK+Tav5oFDPuciCU6MJB8EIZ9UQG5hXOUv3VDBEEd/m7qwaefDf0zvtQ+PBR7xC
         JKjdujPc3Sj4/H+dszxxSSH0rTEjLimQk70swtQprJE4wNrOv9md4bn5jt2Dhuxdwm8x
         /xOzG74p3ZvaGZialvs7hLncSx/KdvRW0kEvY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Andrey Yurovsky <yurovsky@gmail.com>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/25] nandsim: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:17 +0400
Message-Id: <1277806517-30908-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/mtd/nand/nandsim.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 261337e..c25648b 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -553,8 +553,8 @@ static uint64_t divide(uint64_t n, uint32_t d)
  */
 static int init_nandsim(struct mtd_info *mtd)
 {
-	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
-	struct nandsim   *ns   = (struct nandsim *)(chip->priv);
+	struct nand_chip *chip = mtd->priv;
+	struct nandsim   *ns   = chip->priv;
 	int i, ret = 0;
 	uint64_t remains;
 	uint64_t next_offset;
@@ -1877,7 +1877,7 @@ static void switch_state(struct nandsim *ns)
 
 static u_char ns_nand_read_byte(struct mtd_info *mtd)
 {
-        struct nandsim *ns = (struct nandsim *)((struct nand_chip *)mtd->priv)->priv;
+	struct nandsim *ns = ((struct nand_chip *)mtd->priv)->priv;
 	u_char outb = 0x00;
 
 	/* Sanity and correctness checks */
@@ -1950,7 +1950,7 @@ static u_char ns_nand_read_byte(struct mtd_info *mtd)
 
 static void ns_nand_write_byte(struct mtd_info *mtd, u_char byte)
 {
-        struct nandsim *ns = (struct nandsim *)((struct nand_chip *)mtd->priv)->priv;
+	struct nandsim *ns = ((struct nand_chip *)mtd->priv)->priv;
 
 	/* Sanity and correctness checks */
 	if (!ns->lines.ce) {
@@ -2132,7 +2132,7 @@ static uint16_t ns_nand_read_word(struct mtd_info *mtd)
 
 static void ns_nand_write_buf(struct mtd_info *mtd, const u_char *buf, int len)
 {
-        struct nandsim *ns = (struct nandsim *)((struct nand_chip *)mtd->priv)->priv;
+	struct nandsim *ns = ((struct nand_chip *)mtd->priv)->priv;
 
 	/* Check that chip is expecting data input */
 	if (!(ns->state & STATE_DATAIN_MASK)) {
@@ -2159,7 +2159,7 @@ static void ns_nand_write_buf(struct mtd_info *mtd, const u_char *buf, int len)
 
 static void ns_nand_read_buf(struct mtd_info *mtd, u_char *buf, int len)
 {
-        struct nandsim *ns = (struct nandsim *)((struct nand_chip *)mtd->priv)->priv;
+	struct nandsim *ns = ((struct nand_chip *)mtd->priv)->priv;
 
 	/* Sanity and correctness checks */
 	if (!ns->lines.ce) {
@@ -2352,7 +2352,7 @@ module_init(ns_init_module);
  */
 static void __exit ns_cleanup_module(void)
 {
-	struct nandsim *ns = (struct nandsim *)(((struct nand_chip *)nsmtd->priv)->priv);
+	struct nandsim *ns = ((struct nand_chip *)nsmtd->priv)->priv;
 	int i;
 
 	free_nandsim(ns);    /* Free nandsim private resources */
-- 
1.7.0.4

