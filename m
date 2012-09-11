Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2IKLgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:36:35 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:26724 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257Ab2IKLer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IhAQUjBAsBRhAlAiYCAlcGE4gUqGiTN4EhjwOBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505379"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 13/20] Staging: ipack/bridges/tpci200: fix the uninstall the ipack device
Date: Tue, 11 Sep 2012 13:35:06 +0200
Message-Id: <1347363313-17094-14-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
 drivers/staging/ipack/bridges/tpci200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index b928140..77e6392 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -385,7 +385,6 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 		return -ERESTARTSYS;
 
 	tpci200->slots[dev->slot].dev = NULL;
-	ipack_device_unregister(dev);
 	mutex_unlock(&tpci200->mutex);
 
 	return 0;
@@ -614,7 +613,7 @@ static void tpci200_uninstall(struct tpci200_board *tpci200)
 	int i;
 
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		tpci200_slot_unregister(tpci200->slots[i].dev);
+		ipack_device_unregister(tpci200->slots[i].dev);
 
 	tpci200_unregister(tpci200);
 	kfree(tpci200->slots);
-- 
1.7.10.4

