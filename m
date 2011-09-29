Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1I2TsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:48:14 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56975
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755404Ab1I2TsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:48:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 22/24] Staging: hv: mousevsc: Cleanup  mousevsc_on_device_add()
Date: Thu, 29 Sep 2011 11:55:02 -0700
Message-Id: <1317322504-9788-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup  mousevsc_on_device_add().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index a526ba5..98ae062 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -513,12 +513,10 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 	input_device->hid_device = hid_dev;
 }
 
-static int mousevsc_on_device_add(struct hv_device *device,
-					void *additional_info)
+static int mousevsc_on_device_add(struct hv_device *device)
 {
 	int ret = 0;
 	struct mousevsc_dev *input_dev;
-	struct hv_driver *input_drv;
 
 	input_dev = alloc_input_device(device);
 
@@ -551,9 +549,6 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		return ret;
 	}
 
-	input_drv = drv_to_hv_drv(input_dev->device->device.driver);
-
-
 
 	/* Send the report desc back up */
 	/* workaround SA-167 */
@@ -573,7 +568,7 @@ static int mousevsc_probe(struct hv_device *dev,
 {
 
 	/* Call to the vsc driver to add the device */
-	return mousevsc_on_device_add(dev, NULL);
+	return mousevsc_on_device_add(dev);
 
 }
 
-- 
1.7.4.1

