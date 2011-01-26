Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1AZK2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:28:32 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:44915 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1AZK2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:28:31 -0500
X-IronPort-AV: E=Sophos;i="4.60,379,1291611600"; 
   d="scan'208";a="27823445"
From: Bob Liu <lliubbo@gmail.com>
To: linux-kernel@vger.kernel.org
CC: chrisw@sous-sol.org, tomas.winkler@intel.com, johannes.berg@intel.com,
        dmitry.torokhov@gmail.com, gregkh@suse.de, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH V2] firmware_classs: change val uevent's type to bool
Date: Wed, 26 Jan 2011 18:33:32 +0800
Message-ID: <1296038012-16656-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some place in firmware_class.c using "int uevent" define, but others use "bool
uevent".
This patch replace all int uevent define to bool.

Changes since V1:
	johannes: remove no-op

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/base/firmware_class.c |    7 +++----
 include/linux/firmware.h      |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 40af43e..8c798ef 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -593,8 +593,7 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-        int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent, false);
+        return _request_firmware(firmware_p, name, device, true, false);
 }
 
 /**
@@ -618,7 +617,7 @@ struct firmware_work {
 	struct device *device;
 	void *context;
 	void (*cont)(const struct firmware *fw, void *context);
-	int uevent;
+	bool uevent;
 };
 
 static int request_firmware_work_func(void *arg)
@@ -661,7 +660,7 @@ static int request_firmware_work_func(void *arg)
  **/
 int
 request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 53d1e6c..21b3e75 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -39,7 +39,7 @@ struct builtin_fw {
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
 
@@ -52,7 +52,7 @@ static inline int request_firmware(const struct firmware **fw,
 	return -EINVAL;
 }
 static inline int request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-- 
1.6.3.3

