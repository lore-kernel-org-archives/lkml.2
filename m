Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2IKLe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:34:57 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:55378 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab2IKLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IhAQUjBAsBNBIQJQImAgJXBhOIFKhokzeBIY8DgRIDlV2JM4lS
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505389"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 17/20] Staging: ipack/bridges/tpci200: delete ipack_device_unregister calls when exiting
Date: Tue, 11 Sep 2012 13:35:10 +0200
Message-Id: <1347363313-17094-18-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the ipack_bus_unregister() takes care of unregistering the devices plugged
in the carrier, it is not needed to do it in the carrier driver.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 77e6392..8de74c9 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -610,11 +610,6 @@ static int tpci200_reset_timeout(struct ipack_device *dev)
 
 static void tpci200_uninstall(struct tpci200_board *tpci200)
 {
-	int i;
-
-	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		ipack_device_unregister(tpci200->slots[i].dev);
-
 	tpci200_unregister(tpci200);
 	kfree(tpci200->slots);
 }
@@ -751,8 +746,8 @@ out_err_info:
 
 static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 {
-	tpci200_uninstall(tpci200);
 	ipack_bus_unregister(tpci200->info->ipack_bus);
+	tpci200_uninstall(tpci200);
 
 	kfree(tpci200->info);
 	kfree(tpci200);
-- 
1.7.10.4

