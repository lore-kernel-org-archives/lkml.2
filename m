Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2LQW1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:27:17 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:43557 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2LQW1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:27:16 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1355783207!6900653!22
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] HID: introduce helper for hid_driver boilerplate
Date: Mon, 17 Dec 2012 15:26:55 -0700
User-Agent: KMail/1.9.9
CC: <jkosina@suse.cz>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201212171526.55969.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the module_hid_driver macro which is a convenience macro
for HID driver modules similar to module_usb_driver. It is intended
to be used by drivers with init/exit sections that do nothing but
register/unregister the HID driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/hid.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7330a0f..d6c71a6 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -700,6 +700,18 @@ extern int __must_check __hid_register_driver(struct hid_driver *,
 
 extern void hid_unregister_driver(struct hid_driver *);
 
+/**
+ * module_hid_driver() - Helper macro for registering a HID driver
+ * @__hid_driver: hid_driver struct
+ *
+ * Helper macro for HID drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_hid_driver(__hid_driver) \
+	module_driver(__hid_driver, hid_register_driver, \
+		      hid_unregister_driver)
+
 extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
 extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
 extern int hidinput_connect(struct hid_device *hid, unsigned int force);
-- 
1.8.0.2

