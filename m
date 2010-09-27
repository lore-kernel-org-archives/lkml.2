Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0I0Cfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:35:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55645 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab0I0Cfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q6P23zj66c61cridocZA2jez3lSPPOSAqovNw2saO3DqLxOC+D4ft6n3BTaTE0V9U0
         YXScLYOt6FAEmRveC66kyxSKeDDjFEhBu51V6+uF6PcxKiHTRhN2np9jZDcvri0a1OBG
         E9p9yoh7WRXHX8z+m0mun86XaxTcrbxqcXUWE=
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/4] net: r6040: store BIOS default MAC in perm_add
Date: Sun, 26 Sep 2010 23:35:07 -0300
Message-Id: <1285554907-4495-4-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.2.3.313.gcd15
In-Reply-To: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
References: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 drivers/net/r6040.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 142c381..5780d08 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -740,6 +740,9 @@ static void r6040_mac_address(struct net_device *dev)
 	iowrite16(adrp[0], ioaddr + MID_0L);
 	iowrite16(adrp[1], ioaddr + MID_0M);
 	iowrite16(adrp[2], ioaddr + MID_0H);
+
+	/* Store MAC Address in perm_addr */
+	memcpy(dev->perm_addr, dev->dev_addr, ETH_ALEN);
 }
 
 static int r6040_open(struct net_device *dev)
-- 
1.7.2.3.313.gcd15

