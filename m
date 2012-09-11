Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2IKLez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:34:55 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:55378 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238Ab2IKLeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IhAQUjBAsBRhAlAiYCAlcGE4gUqGiTN4EhjwOBEgOVXYkziVI
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505390"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 18/20] Staging: ipack/bridges/tpci200: remove tpci200_slot_unregister
Date: Tue, 11 Sep 2012 13:35:11 +0200
Message-Id: <1347363313-17094-19-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
 drivers/staging/ipack/bridges/tpci200.c |   26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 8de74c9..0823cdb 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -28,8 +28,6 @@ static u16 tpci200_status_error[] = {
 	TPCI200_D_ERROR,
 };
 
-static int tpci200_slot_unregister(struct ipack_device *dev);
-
 static struct tpci200_board *check_slot(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200;
@@ -368,28 +366,6 @@ out_unlock:
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
@@ -619,7 +595,7 @@ static const struct ipack_bus_ops tpci200_bus_ops = {
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

