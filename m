Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2IJIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:51:40 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:27136 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2IJIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IhAQUjDwE0EhAlAiYCAlcGE4gUqBWSO4EhjxaBEgOVXYkziVI
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262519"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 19/20] Staging: ipack: delete .remove_device() callback
Date: Mon, 10 Sep 2012 10:51:57 +0200
Message-Id: <1347267118-9580-19-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the IP module driver takes care of freeing its resources.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    1 -
 drivers/staging/ipack/ipack.h           |    3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index e58e312..531dfd5 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -597,7 +597,6 @@ static struct ipack_bus_ops tpci200_bus_ops = {
 	.unmap_space = tpci200_slot_unmap_space,
 	.request_irq = tpci200_request_irq,
 	.free_irq = tpci200_free_irq,
-	.remove_device = NULL,
 	.get_clockrate = tpci200_get_clockrate,
 	.set_clockrate = tpci200_set_clockrate,
 	.get_error     = tpci200_get_error,
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index e2cbf4a..33311c7 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -113,7 +113,6 @@ struct ipack_driver {
  *	@unmap_space: unmap IP address space
  *	@request_irq: request IRQ
  *	@free_irq: free IRQ
- *	@remove_device: tell the bridge module that the device has been removed
  *	@get_clockrate: Returns the clockrate the carrier is currently
  *		communicating with the device at.
  *	@set_clockrate: Sets the clock-rate for carrier / module communication.
@@ -129,8 +128,6 @@ struct ipack_bus_ops {
 	int (*unmap_space) (struct ipack_device *dev, int space);
 	int (*request_irq) (struct ipack_device *dev, int vector, int (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
-	int (*remove_device) (struct ipack_device *dev);
-
 	int (*get_clockrate) (struct ipack_device *dev);
 	int (*set_clockrate) (struct ipack_device *dev, int mherz);
 	int (*get_error) (struct ipack_device *dev);
-- 
1.7.10.4

