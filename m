Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1CLWcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:32:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1CLWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Im48EylmaCHkjpoj+qTEFtP4q9ctniFCDOxYgauWyb/oCsdI6VfogdqR8O0xXjuCGa
         fbRMNC0VNf9adq5x62SWS0CAJaAYb+T32VDbMm9sfJhw0b9X0stPlOmWQ+l6jXwjQ9hm
         WcO7UZ+ns2yr9Rz2bXfCZbcv73LKANfnfiOb0=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 2/4] PLATFORM: Introduce registration function for async
 platform data maps
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:32:19 +0000
Message-ID: <20110312223219.27020.60965.stgit@otae.warmcat.com>
In-Reply-To: <20110312222633.27020.19543.stgit@otae.warmcat.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a small platform API that lets a board definition file
register a mapping structure for asynchronously probed devices so
platform_data can be attached to them at probe time.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 drivers/base/platform.c         |   21 +++++++++++++++++++++
 include/linux/platform_device.h |    3 +++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..180e372 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -31,6 +31,12 @@ struct device platform_bus = {
 };
 EXPORT_SYMBOL_GPL(platform_bus);
 
+struct platform_async_platform_data *platform_async_platform_data_map;
+EXPORT_SYMBOL_GPL(platform_async_platform_data_map);
+
+int platform_async_platform_data_count;
+EXPORT_SYMBOL_GPL(platform_async_platform_data_count);
+
 /**
  * platform_get_resource - get a resource for a device
  * @dev: platform device
@@ -1332,3 +1338,18 @@ void __init early_platform_cleanup(void)
 	}
 }
 
+/**
+ * platform_async_platform_data_register - register an array of async-
+ *				probed bus / device names mapping to
+ *				plaform_data for that device.
+ * @map:	the array of devname vs platform_data mapping structs
+ * @count:	the count of structs in the @map array
+ */
+
+void platform_async_platform_data_register(
+			    struct platform_async_platform_data *map, int count)
+{
+	platform_async_platform_data_map = map;
+	platform_async_platform_data_count = count;
+}
+EXPORT_SYMBOL_GPL(platform_async_platform_data_register);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d8c0ba9..19ea497 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -210,4 +210,7 @@ struct platform_async_platform_data {
 	void *platform_data;
 };
 
+extern void platform_async_platform_data_register(
+			   struct platform_async_platform_data *map, int count);
+
 #endif /* _PLATFORM_DEVICE_H_ */

