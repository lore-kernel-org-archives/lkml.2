Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2IJIxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:53:08 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:27136 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2IJIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IhAQUjBAsBRhAlAiYCAlcGE4gUqBWSO4EhjxaBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262507"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 13/20] Staging: ipack/bridges/tpci200: fix the uninstall the ipack device
Date: Mon, 10 Sep 2012 10:51:51 +0200
Message-Id: <1347267118-9580-13-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the call to the ipack_device_unregister() function to avoid the
strange way it was doing, as the device model will take care of calling
the bus's .remove function when a device is being unregistered.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index c1ce311..293456b 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -30,8 +30,6 @@ static u16 tpci200_status_error[] = {
 
 static struct ipack_bus_ops tpci200_bus_ops;
 
-static int tpci200_slot_unregister(struct ipack_device *dev);
-
 static struct tpci200_board *check_slot(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200;
@@ -387,7 +385,6 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 		return -ERESTARTSYS;
 
 	tpci200->slots[dev->slot].dev = NULL;
-	ipack_device_unregister(dev);
 	mutex_unlock(&tpci200->mutex);
 
 	return 0;
@@ -616,7 +613,7 @@ static void tpci200_uninstall(struct tpci200_board *tpci200)
 	int i;
 
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		tpci200_slot_unregister(tpci200->slots[i].dev);
+		ipack_device_unregister(tpci200->slots[i].dev);
 
 	tpci200_unregister(tpci200);
 	kfree(tpci200->slots);
-- 
1.7.10.4

