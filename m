Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1GLKjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:39:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47118 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1GLKjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:39:16 -0400
Date: Tue, 12 Jul 2011 16:25:16 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: mikem@ring3k.org, pshah.mumbai@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging: rtl8192e: fixed style issues found by
	checkpatch.pl
Message-ID: <20110712105516.GA16196@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_93cx6.c file that fixes style issues
found by the checkpatch.pl tool
- extra spaces
- invalid comment style

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/rtl8192e/r8180_93cx6.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl8192e/r8180_93cx6.c
index 55d4f56..ee07a15 100644
--- a/drivers/staging/rtl8192e/r8180_93cx6.c
+++ b/drivers/staging/rtl8192e/r8180_93cx6.c
@@ -23,12 +23,14 @@
 static void eprom_cs(struct r8192_priv *priv, short bit)
 {
 	if (bit)
+		/* enable EPROM */
 		write_nic_byte(priv, EPROM_CMD,
 			       (1<<EPROM_CS_SHIFT) |
-			       read_nic_byte(priv, EPROM_CMD)); //enable EPROM
+			       read_nic_byte(priv, EPROM_CMD));
 	else
+		/* disable EPROM */
 		write_nic_byte(priv, EPROM_CMD, read_nic_byte(priv, EPROM_CMD)
-			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
+			       &~(1<<EPROM_CS_SHIFT));
 
 	udelay(EPROM_DELAY);
 }
@@ -91,7 +93,7 @@ u32 eprom_read(struct r8192_priv *priv, u32 addr)
 	u32 ret;
 
 	ret = 0;
-        //enable EPROM programming
+	/* enable EPROM programming */
 	write_nic_byte(priv, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	udelay(EPROM_DELAY);
@@ -120,13 +122,17 @@ u32 eprom_read(struct r8192_priv *priv, u32 addr)
 	eprom_send_bits_string(priv, read_cmd, 3);
 	eprom_send_bits_string(priv, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/*
+	 * keep chip pin D to low state while reading.
+	 * I'm unsure if it is necessary, but anyway shouldn't hurt
+	 */
 	eprom_w(priv, 0);
 
 	for (i = 0; i < 16; i++) {
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+		/*
+		 * eeprom needs a clk cycle between writing opcode&adr
+		 * and reading data. (eeprom outs a dummy 0)
+		 */
 		eprom_ck_cycle(priv);
 		ret |= (eprom_r(priv)<<(15-i));
 	}
@@ -134,7 +140,7 @@ u32 eprom_read(struct r8192_priv *priv, u32 addr)
 	eprom_cs(priv, 0);
 	eprom_ck_cycle(priv);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte(priv, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.7.1

