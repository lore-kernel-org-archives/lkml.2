Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0KUCww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:52:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1662 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab0KUCj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:59 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/62] eepro: Use static const
Date: Sat, 20 Nov 2010 18:38:20 -0800
Message-Id: <926c2282ee57805ec9459b127b8244d7a5734fb4.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  13007	     97	   3888	  16992	   4260	drivers/net/eepro.o.old
  12969	     97	   3888	  16954	   423a	drivers/net/eepro.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/eepro.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 6fa4227..eb35951 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -891,12 +891,13 @@ err:
    there is non-reboot way to recover if something goes wrong.
    */
 
-static char irqrmap[] = {-1,-1,0,1,-1,2,-1,-1,-1,0,3,4,-1,-1,-1,-1};
-static char irqrmap2[] = {-1,-1,4,0,1,2,-1,3,-1,4,5,6,7,-1,-1,-1};
+static const char irqrmap[] = {-1,-1,0,1,-1,2,-1,-1,-1,0,3,4,-1,-1,-1,-1};
+static const char irqrmap2[] = {-1,-1,4,0,1,2,-1,3,-1,4,5,6,7,-1,-1,-1};
 static int	eepro_grab_irq(struct net_device *dev)
 {
-	int irqlist[] = { 3, 4, 5, 7, 9, 10, 11, 12, 0 };
-	int *irqp = irqlist, temp_reg, ioaddr = dev->base_addr;
+	static const int irqlist[] = { 3, 4, 5, 7, 9, 10, 11, 12, 0 };
+	const int *irqp = irqlist;
+	int temp_reg, ioaddr = dev->base_addr;
 
 	eepro_sw2bank1(ioaddr); /* be CAREFUL, BANK 1 now */
 
-- 
1.7.3.2.245.g03276.dirty

