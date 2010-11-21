Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0KUCzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:55:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1630 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0KUCjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:42 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/62] 3c503: Use static const
Date: Sat, 20 Nov 2010 18:38:03 -0800
Message-Id: <69724d82dfab68246d76ba62a0d4b9315fbdfeb3.1290305775.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   7938	    140	   1688	   9766	   2626	drivers/net/3c503.o.new
   7951	    140	   1688	   9779	   2633	drivers/net/3c503.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/3c503.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/3c503.c b/drivers/net/3c503.c
index 4777a1c..d84f6e8 100644
--- a/drivers/net/3c503.c
+++ b/drivers/net/3c503.c
@@ -392,8 +392,8 @@ el2_open(struct net_device *dev)
     int retval;
 
     if (dev->irq < 2) {
-	int irqlist[] = {5, 9, 3, 4, 0};
-	int *irqp = irqlist;
+	static const int irqlist[] = {5, 9, 3, 4, 0};
+	const int *irqp = irqlist;
 
 	outb(EGACFR_NORM, E33G_GACFR);	/* Enable RAM and interrupts. */
 	do {
-- 
1.7.3.2.245.g03276.dirty

