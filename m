Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2ILNB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:01:59 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab2ILMz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511785"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 17/24] Staging: ipack/devices/ipoctal: Clean up device removal.
Date: Wed, 12 Sep 2012 14:55:39 +0200
Message-Id: <1347454546-23236-17-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Make use of dev_set_drvdata() and dev_get_drvdata() to store and obtain
a pointer to the ipoctal struct corresponding to a struct dev.
Previously we relied on a private list of devices.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 8e61ebd..b84ab5e 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -725,6 +725,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 	if (res)
 		goto out_uninst;
 
+	dev_set_drvdata(&dev->dev, ipoctal);
 	list_add_tail(&ipoctal->list, &ipoctal_list);
 	return 0;
 
@@ -751,14 +752,9 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	kfree(ipoctal);
 }
 
-static void ipoctal_remove(struct ipack_device *device)
+static void ipoctal_remove(struct ipack_device *idev)
 {
-	struct ipoctal *ipoctal, *next;
-
-	list_for_each_entry_safe(ipoctal, next, &ipoctal_list, list) {
-		if (ipoctal->dev == device)
-			__ipoctal_remove(ipoctal);
-	}
+	__ipoctal_remove(dev_get_drvdata(&idev->dev));
 }
 
 static DEFINE_IPACK_DEVICE_TABLE(ipoctal_ids) = {
-- 
1.7.10.4

