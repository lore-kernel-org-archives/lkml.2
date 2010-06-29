Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0F2KTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:19:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0F2KPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GFk7m9HCUso3mwgIIcsEFA7d4wBMt7eH2P0ifNYDrfwDCroAWcD2ZJrEeECFqBhttv
         Qyo+XeSi0oZhqIaqyXFCPqEk1U2Bv/2yPbpQz0U70WL23WsUtwlLFB5CT6hTWk6z3dsy
         eouN10pJKVeYKO7+kbP5dk4bmQr5voy9bLWGg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/25] mtd_dataflash: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:13 +0400
Message-Id: <1277806514-30874-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/mtd/devices/mtd_dataflash.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 1981740..c5015cc 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -141,7 +141,7 @@ static int dataflash_waitready(struct spi_device *spi)
  */
 static int dataflash_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_device	*spi = priv->spi;
 	struct spi_transfer	x = { .tx_dma = 0, };
 	struct spi_message	msg;
@@ -231,7 +231,7 @@ static int dataflash_erase(struct mtd_info *mtd, struct erase_info *instr)
 static int dataflash_read(struct mtd_info *mtd, loff_t from, size_t len,
 			       size_t *retlen, u_char *buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_transfer	x[2] = { { .tx_dma = 0, }, };
 	struct spi_message	msg;
 	unsigned int		addr;
@@ -304,7 +304,7 @@ static int dataflash_read(struct mtd_info *mtd, loff_t from, size_t len,
 static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 				size_t * retlen, const u_char * buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_device	*spi = priv->spi;
 	struct spi_transfer	x[2] = { { .tx_dma = 0, }, };
 	struct spi_message	msg;
@@ -515,7 +515,7 @@ static ssize_t otp_read(struct spi_device *spi, unsigned base,
 static int dataflash_read_fact_otp(struct mtd_info *mtd,
 		loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	int			status;
 
 	/* 64 bytes, from 0..63 ... start at 64 on-chip */
@@ -532,7 +532,7 @@ static int dataflash_read_fact_otp(struct mtd_info *mtd,
 static int dataflash_read_user_otp(struct mtd_info *mtd,
 		loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	int			status;
 
 	/* 64 bytes, from 0..63 ... start at 0 on-chip */
@@ -553,7 +553,7 @@ static int dataflash_write_user_otp(struct mtd_info *mtd,
 	const size_t		l = 4 + 64;
 	uint8_t			*scratch;
 	struct spi_transfer	t;
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	int			status;
 
 	if (len > 64)
-- 
1.7.0.4

