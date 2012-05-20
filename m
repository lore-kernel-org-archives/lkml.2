Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2EVNOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:14:32 -0400
Received: from mail.mimuw.edu.pl ([193.0.96.6]:49095 "EHLO mail.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2EVNOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:14:30 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2012 09:14:30 EDT
From: Marek Marczykowski <marmarek@invisiblethingslab.com>
Date: Sun, 20 May 2012 13:45:10 +0200
Subject: [PATCH] xen: do not disable netfront in dom0
Organization: Invisible Things Lab
To: xen-devel@lists.xen.org
Cc: Marek Marczykowski <marmarek@invisiblethingslab.com>,
        virtualization@lists.linux-foundation.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20120522130558.D828E6C7@duch.mimuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netfront driver can be also useful in dom0, eg when all NICs are assigned to
some domU (aka driver domain). Then using netback in domU and netfront in dom0
is the only way to get network access in dom0.

Signed-off-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
---
 drivers/net/xen-netfront.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 698b905..e31ebff 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1953,9 +1953,6 @@ static int __init netif_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	if (xen_initial_domain())
-		return 0;
-
 	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
 
 	return xenbus_register_frontend(&netfront_driver);
@@ -1965,9 +1962,6 @@ module_init(netif_init);
 
 static void __exit netif_exit(void)
 {
-	if (xen_initial_domain())
-		return;
-
 	xenbus_unregister_driver(&netfront_driver);
 }
 module_exit(netif_exit);
-- 
1.7.4.4

