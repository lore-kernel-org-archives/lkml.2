Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1CPVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:15 -0400
Received: from kroah.org ([198.145.64.141]:42545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1CPVLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bob Liu <lliubbo@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/50] firmware_classs: change val uevent's type to bool
Date: Wed, 16 Mar 2011 14:10:44 -0700
Message-Id: <1300309888-5028-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>

Some place in firmware_class.c using "int uevent" define, but others use "bool
uevent".
This patch replace all int uevent define to bool.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.4.1

