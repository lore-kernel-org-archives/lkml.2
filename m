Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2GTHi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:38:56 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50567 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127Ab2GTHiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:38:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AioJAAIKCVBbdWOb/2dsb2JhbABFhDCBAESzSoEHgkoECwFGNQImAl8TiBGsB5MDgSCKNYVFgRIDlUSQCYJhgVQ
X-IronPort-AV: E=Sophos;i="4.77,621,1336341600"; 
   d="scan'208";a="546394750"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: [PATCH 1/3] Staging: ipack/bridges/tpci200: avoid kernel bug when uninstalling a device
Date: Fri, 20 Jul 2012 09:39:03 +0200
Message-Id: <1342769945-6999-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 2b83fa8..a7fb2cf 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -604,8 +604,8 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 	if (mutex_lock_interruptible(&tpci200->mutex))
 		return -ERESTARTSYS;
 
-	ipack_device_unregister(dev);
 	tpci200->slots[dev->slot].dev = NULL;
+	ipack_device_unregister(dev);
 	mutex_unlock(&tpci200->mutex);
 
 	return 0;
-- 
1.7.10.4

