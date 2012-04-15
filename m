Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2DOPj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:39:27 -0400
Received: from vt220.org ([109.74.202.194]:40156 "EHLO vt220.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2DOPj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:39:26 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2012 11:39:26 EDT
Date: Sun, 15 Apr 2012 16:32:20 +0100
From: Steven Young <sdyoung@vt220.org>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] arcnet: Correct incorrect format string in
 ARCnet drivers.
Message-ID: <20120415153220.GA11631@vt220.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch corrects an incorrectly-used format string that causes messages
like:
  
  arc%d: Given: node 00h, shmem 0h, irq 0

  to appear in dmesg at boot/modprobe time for the arcnet-rimi driver and
others.  This applies to linux-3.3.

Signed-off-by: Steven Young <sdyoung@vt220.org>

---

--- linux-3.3-orig/drivers/net/arcnet/arcnet.c	2012-03-18 23:15:34.000000000 +0000
+++ linux-3.3/drivers/net/arcnet/arcnet.c	2012-04-15 15:50:24.000000000 +0100
@@ -346,7 +346,7 @@ struct net_device *alloc_arcdev(const ch
 	struct net_device *dev;
 
 	dev = alloc_netdev(sizeof(struct arcnet_local),
-			   name && *name ? name : "arc%d", arcdev_setup);
+			   name && *name ? name : "arcnet", arcdev_setup);
 	if(dev) {
 		struct arcnet_local *lp = netdev_priv(dev);
 		spin_lock_init(&lp->lock);
