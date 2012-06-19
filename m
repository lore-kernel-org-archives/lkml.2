Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2FSTIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:08:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2FSTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:08:20 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH V2 3/3] staging/rtl8192u: use for loop to assign bit shifted addr
Date: Wed, 20 Jun 2012 00:38:13 +0530
Message-Id: <1340132894-19003-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this change is a rewrite of that bitshifted addr copying
logic with for loop, which can easily understandable.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rtl8192u/r8180_93cx6.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index a72bbd4..815b0f3 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -102,25 +102,16 @@ u32 eprom_read(struct net_device *dev, u32 addr)
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
+		addr_len = 8;
+		for (i = 0; i < addr_len; i++)
+			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
+	} else {
+		addr_len = 6;
+		for (i = 0; i < addr_len; i++)
+			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
 	}
+
 	eprom_cs(dev, 1);
 	eprom_ck_cycle(dev);
 	eprom_send_bits_string(dev, read_cmd, 3);
-- 
1.7.9.5

