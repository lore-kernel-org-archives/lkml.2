Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2IJIvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:51:43 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24804 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab2IJIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IhAQUjBAsBRhAlAiYCAlcGE4gUqBWSO4EhjxaBEgOVXYkziVI
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262517"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 18/20] Staging: ipack/bridges/tpci200: remove tpci200_slot_unregister
Date: Mon, 10 Sep 2012 10:51:56 +0200
Message-Id: <1347267118-9580-18-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not needed as the IP module should free its IRQ using
tpci200_free_irq callback.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 12f2ca6..e58e312 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -368,28 +368,6 @@ out_unlock:
 	return 0;
 }
 
-static int tpci200_slot_unregister(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200;
-
-	if (dev == NULL)
-		return -ENODEV;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	tpci200_free_irq(dev);
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	tpci200->slots[dev->slot].dev = NULL;
-	mutex_unlock(&tpci200->mutex);
-
-	return 0;
-}
-
 static int tpci200_slot_map_space(struct ipack_device *dev,
 				  unsigned int memory_size, int space)
 {
@@ -619,7 +597,7 @@ static struct ipack_bus_ops tpci200_bus_ops = {
 	.unmap_space = tpci200_slot_unmap_space,
 	.request_irq = tpci200_request_irq,
 	.free_irq = tpci200_free_irq,
-	.remove_device = tpci200_slot_unregister,
+	.remove_device = NULL,
 	.get_clockrate = tpci200_get_clockrate,
 	.set_clockrate = tpci200_set_clockrate,
 	.get_error     = tpci200_get_error,
-- 
1.7.10.4

