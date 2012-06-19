Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2FSTF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51262 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2FSTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:05:55 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
Date: Wed, 20 Jun 2012 00:35:42 +0530
Message-Id: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed some of the coding style problems reported by checkpatch

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rtl8192u/r8180_93cx6.c |   36 +++++++++++++++++---------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index 3c515b7..19f5270 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -22,13 +22,16 @@
 
 void eprom_cs(struct net_device *dev, short bit)
 {
-	if(bit)
+	if (bit) {
+		/* enable EPROM */
 		write_nic_byte_E(dev, EPROM_CMD,
-			       (1<<EPROM_CS_SHIFT) | \
-			       read_nic_byte_E(dev, EPROM_CMD)); //enable EPROM
-	else
-		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)\
-			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
+				(1<<EPROM_CS_SHIFT) |
+				read_nic_byte_E(dev, EPROM_CMD));
+	} else {
+		/* disable EPROM */
+		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)
+			       & ~(1<<EPROM_CS_SHIFT));
+	}
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -38,24 +41,24 @@ void eprom_cs(struct net_device *dev, short bit)
 void eprom_ck_cycle(struct net_device *dev)
 {
 	write_nic_byte_E(dev, EPROM_CMD,
-		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev,EPROM_CMD));
+		       (1<<EPROM_CK_SHIFT) | read_nic_byte_E(dev, EPROM_CMD));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 	write_nic_byte_E(dev, EPROM_CMD,
-		       read_nic_byte_E(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
+		       read_nic_byte_E(dev, EPROM_CMD) & ~(1<<EPROM_CK_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 }
 
 
-void eprom_w(struct net_device *dev,short bit)
+void eprom_w(struct net_device *dev, short bit)
 {
-	if(bit)
-		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
-			       read_nic_byte_E(dev,EPROM_CMD));
+	if (bit)
+		write_nic_byte_E(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) |
+			       read_nic_byte_E(dev, EPROM_CMD));
 	else
-		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev,EPROM_CMD)\
-			       &~(1<<EPROM_W_SHIFT));
+		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)
+			       & ~(1<<EPROM_W_SHIFT));
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -66,11 +69,10 @@ short eprom_r(struct net_device *dev)
 {
 	short bit;
 
-	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
+	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
 	udelay(EPROM_DELAY);
 
-	if(bit) return 1;
-	return 0;
+	return !!bit;
 }
 
 
-- 
1.7.9.5

