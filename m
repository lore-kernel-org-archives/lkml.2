Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2JORjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:39:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42960 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2JORjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:39:18 -0400
From: Pranav Ravichandran <me@onloop.net>
To: gregkh@linuxfoundation.org, me@onloop.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: sbe-2t3e3: fix coding style issues in netdev.c
Date: Mon, 15 Oct 2012 23:08:26 +0530
Message-Id: <1350322706-31687-1-git-send-email-me@onloop.net>
X-Mailer: git-send-email 1.7.12.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a POINTER_LOCATION error(changed foo* bar to foo *bar)
and an ASSIGN_IN_IF error(moved assignment out of if condition).

Signed-off-by: Pranav Ravichandran <me@onloop.net>
---
 drivers/staging/sbe-2t3e3/netdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/netdev.c b/drivers/staging/sbe-2t3e3/netdev.c
index 180c963..1f5088b 100644
--- a/drivers/staging/sbe-2t3e3/netdev.c
+++ b/drivers/staging/sbe-2t3e3/netdev.c
@@ -57,7 +57,7 @@ static int t3e3_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return 0;
 }
 
-static struct net_device_stats* t3e3_get_stats(struct net_device *dev)
+static struct net_device_stats *t3e3_get_stats(struct net_device *dev)
 {
 	struct net_device_stats *nstats = &dev->stats;
 	struct channel *sc = dev_to_priv(dev);
@@ -134,7 +134,8 @@ int setup_device(struct net_device *dev, struct channel *sc)
 	dev->tx_queue_len = 100;
 	hdlc->xmit = t3e3_if_start_xmit;
 	hdlc->attach = t3e3_attach;
-	if ((retval = register_hdlc_device(dev))) {
+	retval = register_hdlc_device(dev);
+	if (retval) {
 		dev_err(&sc->pdev->dev, "error registering HDLC device\n");
 		return retval;
 	}
-- 
1.7.12.2

