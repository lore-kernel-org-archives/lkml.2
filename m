Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1CFHIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:08:35 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:37781 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CFHIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:08:34 -0500
Date: Sun, 6 Mar 2011 02:08:32 -0500
From: j223yang@asset.uwaterloo.ca
To: rdunlap@xenotime.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch] ariadne: fix possible null dereference
Message-ID: <20110306070832.GA26188@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
I have tested my patch, and it is ok now.
Could you please try patching again? Sorry for previous trouble.
Thank you!
 
Jinqiu
------------------------------------------------------
This patch fixes bugzilla #13853:
https://bugzilla.kernel.org/show_bug.cgi?id=13853

The patch removes dereference of 'dev' after testing for NULL.

Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
---
 ariadne.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
--- a/drivers/net/ariadne.c	2011-03-04 11:16:42.332164362 -0500
+++ b/drivers/net/ariadne.c	2011-03-05 21:11:52.949164759 -0500
@@ -420,7 +420,7 @@ static inline void ariadne_reset(struct 
 static irqreturn_t ariadne_interrupt(int irq, void *data)
 {
     struct net_device *dev = (struct net_device *)data;
-    volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
+    volatile struct Am79C960 *lance;
     struct ariadne_private *priv;
     int csr0, boguscnt;
     int handled = 0;
@@ -430,6 +430,7 @@ static irqreturn_t ariadne_interrupt(int
 	return IRQ_NONE;
     }
 
+    lance = (struct Am79C960 *)dev->base_addr;
     lance->RAP = CSR0;			/* PCnet-ISA Controller Status */
 
     if (!(lance->RDP & INTR))		/* Check if any interrupt has been */
