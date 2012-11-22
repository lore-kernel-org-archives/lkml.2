Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab2KVTXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:23:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59210 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab2KVTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:23:34 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, patches@linaro.org
Subject: [PATCH] usb: gadget: s3c-hsotg: Fix invalid free of devm_ allocated data
Date: Thu, 22 Nov 2012 13:55:16 +0530
Message-Id: <1353572716-21285-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since hsotg object is allocated using devm_kzalloc() API, there is no
need to free this explicitly. But we need to keep the release API to
prevent warnings.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/usb/gadget/s3c-hsotg.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 6f696ee..093a56a 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3477,12 +3477,11 @@ static void __devexit s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
 /**
  * s3c_hsotg_release - release callback for hsotg device
  * @dev: Device to for which release is called
+ *
+ * Nothing to do as the resource is allocated using devm_ API.
  */
 static void s3c_hsotg_release(struct device *dev)
 {
-	struct s3c_hsotg *hsotg = dev_get_drvdata(dev);
-
-	kfree(hsotg);
 }
 
 /**
-- 
1.7.4.1

