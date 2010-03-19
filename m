Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0CSCrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:47:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52881 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0CSCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Np1KnJ8n23qsRWTnS1PxxkQk3gd/AkxSi9VGI2gE6kbFzCCJXA/b4N+I+3KIZUlivh
         +bALqeFatajZqlRX1PRFIpM7C4hIezMEmBHA0kUtaY6q1BdFSpqRPG6Hxtr+AtlVPZnw
         ohZPG4dQWJC2ww0rah+MGCT+6gROTtJbTJMgQ=
From: Imtiaz Rahi <imtiaz.rahi@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Imtiaz Rahi <imtiaz.rahi@gmail.com>
Subject: [PATCH] Staging: rtl8192su: fix various coding style issues in r8180_93cx6.c
Date: Fri, 19 Mar 2010 08:47:03 +0600
Message-Id: <1268966823-15418-1-git-send-email-imtiaz.rahi@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to the r8180_93cx6.c file that fixes various coding style
warnings and errors found by checkpatch.pl

Signed-off-by: Imtiaz Rahi <imtiaz.rahi@gmail.com>
---
 drivers/staging/rtl8192su/r8180_93cx6.c |   92 ++++++++++++++++---------------
 1 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8180_93cx6.c b/drivers/staging/rtl8192su/r8180_93cx6.c
index 8878cfe..5f581db 100644
--- a/drivers/staging/rtl8192su/r8180_93cx6.c
+++ b/drivers/staging/rtl8192su/r8180_93cx6.c
@@ -22,13 +22,14 @@
 
 void eprom_cs(struct net_device *dev, short bit)
 {
-	if(bit)
-		write_nic_byte_E(dev, EPROM_CMD,
-			       (1<<EPROM_CS_SHIFT) | \
-			       read_nic_byte_E(dev, EPROM_CMD)); //enable EPROM
+	if (bit)
+		/* enable EPROM */
+		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_CS_SHIFT) | \
+					read_nic_byte_E(dev, EPROM_CMD));
 	else
-		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)\
-			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
+		/* disable EPROM */
+		write_nic_byte_E(dev, EPROM_CMD,
+			read_nic_byte_E(dev, EPROM_CMD) & ~(1<<EPROM_CS_SHIFT));
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -38,24 +39,24 @@ void eprom_cs(struct net_device *dev, short bit)
 void eprom_ck_cycle(struct net_device *dev)
 {
 	write_nic_byte_E(dev, EPROM_CMD,
-		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev,EPROM_CMD));
+			(1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev, EPROM_CMD));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 	write_nic_byte_E(dev, EPROM_CMD,
-		       read_nic_byte_E(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
+			read_nic_byte_E(dev, EPROM_CMD) & ~(1<<EPROM_CK_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 }
 
 
-void eprom_w(struct net_device *dev,short bit)
+void eprom_w(struct net_device *dev, short bit)
 {
-	if(bit)
+	if (bit)
 		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
-			       read_nic_byte_E(dev,EPROM_CMD));
+					read_nic_byte_E(dev, EPROM_CMD));
 	else
-		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev,EPROM_CMD)\
-			       &~(1<<EPROM_W_SHIFT));
+		write_nic_byte_E(dev, EPROM_CMD,
+			read_nic_byte_E(dev, EPROM_CMD) & ~(1<<EPROM_W_SHIFT));
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -66,10 +67,11 @@ short eprom_r(struct net_device *dev)
 {
 	short bit;
 
-	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
+	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
 	udelay(EPROM_DELAY);
 
-	if(bit) return 1;
+	if (bit)
+		return 1;
 	return 0;
 }
 
@@ -78,7 +80,7 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 {
 	int i;
 
-	for(i=0; i<len; i++){
+	for (i = 0; i < len; i++) {
 		eprom_w(dev, b[i]);
 		eprom_ck_cycle(dev);
 	}
@@ -88,50 +90,50 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 u32 eprom_read(struct net_device *dev, u32 addr)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	short read_cmd[]={1,1,0};
+	short read_cmd[] = {1, 1, 0};
 	short addr_str[8];
 	int i;
 	int addr_len;
 	u32 ret;
 
-	ret=0;
-        //enable EPROM programming
+	ret = 0;
+	/* enable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
-		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
+			(EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 
-	if (priv->epromtype==EPROM_93c56){
-		addr_str[7]=addr & 1;
-		addr_str[6]=addr & (1<<1);
-		addr_str[5]=addr & (1<<2);
-		addr_str[4]=addr & (1<<3);
-		addr_str[3]=addr & (1<<4);
-		addr_str[2]=addr & (1<<5);
-		addr_str[1]=addr & (1<<6);
-		addr_str[0]=addr & (1<<7);
-		addr_len=8;
-	}else{
-		addr_str[5]=addr & 1;
-		addr_str[4]=addr & (1<<1);
-		addr_str[3]=addr & (1<<2);
-		addr_str[2]=addr & (1<<3);
-		addr_str[1]=addr & (1<<4);
-		addr_str[0]=addr & (1<<5);
-		addr_len=6;
+	if (priv->epromtype == EPROM_93c56) {
+		addr_str[7] = addr & 1;
+		addr_str[6] = addr & (1<<1);
+		addr_str[5] = addr & (1<<2);
+		addr_str[4] = addr & (1<<3);
+		addr_str[3] = addr & (1<<4);
+		addr_str[2] = addr & (1<<5);
+		addr_str[1] = addr & (1<<6);
+		addr_str[0] = addr & (1<<7);
+		addr_len = 8;
+	} else {
+		addr_str[5] = addr & 1;
+		addr_str[4] = addr & (1<<1);
+		addr_str[3] = addr & (1<<2);
+		addr_str[2] = addr & (1<<3);
+		addr_str[1] = addr & (1<<4);
+		addr_str[0] = addr & (1<<5);
+		addr_len = 6;
 	}
 	eprom_cs(dev, 1);
 	eprom_ck_cycle(dev);
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/* keep chip pin D to low state while reading.
+	   I'm unsure if it is necessary, but anyway shouldn't hurt */
 	eprom_w(dev, 0);
 
-	for(i=0;i<16;i++){
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+	for (i = 0; i < 16; i++) {
+		/* eeprom needs a clk cycle between writing opcode&adr
+		   and reading data. (eeprom outs a dummy 0) */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -139,8 +141,8 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
-		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
+			(EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
 }
-- 
1.7.0

