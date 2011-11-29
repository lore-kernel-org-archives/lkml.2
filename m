Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab1LJMwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:52:15 -0500
Received: from www17.your-server.de ([213.133.104.17]:55104 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1LJMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:51:12 -0500
Subject: [PATCH] IPoIB: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.307.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c 2011-11-13 11:07:26.816827448 +0100
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c 2011-11-28 19:51:19.444842130 +0100
@@ -933,7 +933,7 @@ int ipoib_dev_init(struct net_device *de
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/* Allocate RX/TX "rings" to hold queued skbs */
-	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
+	priv->rx_ring = kcalloc(ipoib_recvq_size, sizeof(*priv->rx_ring),
 				GFP_KERNEL);
 	if (!priv->rx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
