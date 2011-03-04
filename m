Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab1CDSIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:08:42 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:57564 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab1CDSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:08:41 -0500
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 13:08:41 EST
Date: Fri, 4 Mar 2011 12:46:26 -0500
From: j223yang@asset.uwaterloo.ca
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] ariadne: fix possible null dereference
Message-ID: <20110304174625.GA31042@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bugzilla #13853:
https://bugzilla.kernel.org/show_bug.cgi?id=13853

The patch removes dereference of 'dev' after testing for NULL.
The source code ariadne.c uses spaces instead of tabs, so the patch
uses spaces too.

Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
---
 drivers/net/ariadne.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
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
     lance->RAP = CSR0;                 /* PCnet-ISA Controller Status */

     if (!(lance->RDP & INTR))          /* Check if any interrupt has been */

