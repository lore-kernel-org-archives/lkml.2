Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2FQNry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 09:47:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2FQNrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 09:47:53 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/rtl8192u: cleanup coding style problems
Date: Sun, 17 Jun 2012 19:17:40 +0530
Message-Id: <1339940861-18258-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings / errors were cleaned

drivers/staging/rtl8192u/r8180_93cx6.c:25: ERROR: space required before the open parenthesis '('
drivers/staging/rtl8192u/r8180_93cx6.c:28: ERROR: do not use C99 // comments
drivers/staging/rtl8192u/r8180_93cx6.c:30: WARNING: line over 80 characters
drivers/staging/rtl8192u/r8180_93cx6.c:31: ERROR: do not use C99 // comments
drivers/staging/rtl8192u/r8180_93cx6.c:41: ERROR: space required after that ',' (ctx:VxV)
drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: need consistent spacing a round '&' (ctx:WxO)
drivers/staging/rtl8192u/r8180_93cx6.c:45: ERROR: space prohibited after that '~' (ctx:OxW)
drivers/staging/rtl8192u/r8180_93cx6.c:51: ERROR: space required after that ',' (ctx:VxV)
drivers/staging/rtl8192u/r8180_93cx6.c:53: ERROR: space required before the open parenthesis '('
drivers/staging/rtl8192u/r8180_93cx6.c:55: ERROR: space required after that ',' (ctx:VxV)
drivers/staging/rtl8192u/r8180_93cx6.c:57: ERROR: space required after that ',' (ctx:VxV)
drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: spaces required around that '=' (ctx:VxV)
drivers/staging/rtl8192u/r8180_93cx6.c:69: ERROR: space prohibited before that close parenthesis ')'
drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: space required before the open parenthesis '('
drivers/staging/rtl8192u/r8180_93cx6.c:72: ERROR: trailing statements should be on next line

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rtl8192u/r8180_93cx6.c |   35 +++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index 3c515b7..e48a5aa 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -22,13 +22,17 @@
 
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
+		write_nic_byte_E(dev, EPROM_CMD,
+				read_nic_byte_E(dev, EPROM_CMD)
+				&~(1<<EPROM_CS_SHIFT));
+	}
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -38,23 +42,23 @@ void eprom_cs(struct net_device *dev, short bit)
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
+		write_nic_byte_E(dev, EPROM_CMD, read_nic_byte_E(dev, EPROM_CMD)
 			       &~(1<<EPROM_W_SHIFT));
 
 	force_pci_posting(dev);
@@ -66,11 +70,10 @@ short eprom_r(struct net_device *dev)
 {
 	short bit;
 
-	bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
+	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
 	udelay(EPROM_DELAY);
 
-	if(bit) return 1;
-	return 0;
+	return bit ? 1: 0;
 }
 
 
-- 
1.7.9.5

