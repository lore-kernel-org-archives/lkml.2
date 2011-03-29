Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1C2WWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:48 -0400
Received: from mail.perches.com ([173.55.12.10]:4395 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab1C2WWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:44 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/23] xo15-ebook: Use pr_<level>
Date: Tue, 29 Mar 2011 15:21:54 -0700
Message-Id: <d3586f0c0089c42d06f13a0f52ea2800325477cf.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.

Remove local #define PREFIX.
Add pr_fmt.
Convert printk to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/xo15-ebook.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index c1372ed..fad153d 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -11,6 +11,8 @@
  *  your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -20,7 +22,6 @@
 #include <acpi/acpi_drivers.h>
 
 #define MODULE_NAME "xo15-ebook"
-#define PREFIX MODULE_NAME ": "
 
 #define XO15_EBOOK_CLASS		MODULE_NAME
 #define XO15_EBOOK_TYPE_UNKNOWN	0x00
@@ -105,7 +106,7 @@ static int ebook_switch_add(struct acpi_device *device)
 	class = acpi_device_class(device);
 
 	if (strcmp(hid, XO15_EBOOK_HID)) {
-		printk(KERN_ERR PREFIX "Unsupported hid [%s]\n", hid);
+		pr_err("Unsupported hid [%s]\n", hid);
 		error = -ENODEV;
 		goto err_free_input;
 	}
-- 
1.7.4.2.g597a6.dirty

