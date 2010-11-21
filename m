Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0KUCxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:53:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1661 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0KUCj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:58 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/62] e2100: Use static const
Date: Sat, 20 Nov 2010 18:38:19 -0800
Message-Id: <7422d8e9b9abd27fb289637518494cfafd0c9db6.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   3447	     76	    784	   4307	   10d3	drivers/net/e2100.o.old
   3484	     76	    784	   4344	   10f8	drivers/net/e2100.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/e2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e2100.c b/drivers/net/e2100.c
index 06e72fb..94ec973 100644
--- a/drivers/net/e2100.c
+++ b/drivers/net/e2100.c
@@ -216,7 +216,7 @@ static int __init e21_probe1(struct net_device *dev, int ioaddr)
 		printk(" %02X", station_addr[i]);
 
 	if (dev->irq < 2) {
-		int irqlist[] = {15, 11, 10, 12, 5, 9, 3, 4};
+		static const int irqlist[] = {15, 11, 10, 12, 5, 9, 3, 4};
 		for (i = 0; i < ARRAY_SIZE(irqlist); i++)
 			if (request_irq (irqlist[i], NULL, 0, "bogus", NULL) != -EBUSY) {
 				dev->irq = irqlist[i];
-- 
1.7.3.2.245.g03276.dirty

