Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1BNIsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 03:48:02 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37643 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1BNIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 03:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZNJyF0mBnEp4W0Zp/wYnJYJLkt3aK2j1q5pZYVF0GzqE1uqpoYP3CHKhNDRnHAiqYS
         L9iIvjG4a5fg0nLCjqjr1fsVCLN2GQD/aczNwQ335sIysf4MBj97dHwLFxdTcqPwDLpm
         y2W1tA4CgzSz9tqnGDbgjbslWeietDqiH4fIg=
Subject: [PATCH] platform-drivers: x86: set acpi_driver.owner
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
        Sujith Thomas <sujith.thomas@intel.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Paul Fox <pgf@laptop.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 14 Feb 2011 16:50:07 +0800
Message-Id: <1297673407.11412.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The owner field provides the link between drivers and modules in sysfs.

After setting the owner field, we can see which module provides which
driver and vice versa by looking at /sys/bus/acpi/drivers/*/module and
/sys/module/*/drivers/acpi:*.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Paul Fox <pgf@laptop.org>
---
 drivers/platform/x86/fujitsu-laptop.c   |    2 ++
 drivers/platform/x86/intel_menlow.c     |    1 +
 drivers/platform/x86/panasonic-laptop.c |    1 +
 drivers/platform/x86/topstar-laptop.c   |    1 +
 drivers/platform/x86/wmi.c              |    1 +
 drivers/platform/x86/xo15-ebook.c       |    1 +
 6 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 95e3b09..cf2e5e1 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1063,6 +1063,7 @@ static struct acpi_driver acpi_fujitsu_driver = {
 		.remove = acpi_fujitsu_remove,
 		.notify = acpi_fujitsu_notify,
 		},
+	.owner = THIS_MODULE,
 };
 
 static const struct acpi_device_id fujitsu_hotkey_device_ids[] = {
@@ -1079,6 +1080,7 @@ static struct acpi_driver acpi_fujitsu_hotkey_driver = {
 		.remove = acpi_fujitsu_hotkey_remove,
 		.notify = acpi_fujitsu_hotkey_notify,
 		},
+	.owner = THIS_MODULE,
 };
 
 static int __init fujitsu_init(void)
diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index eacd5da..567ab4e 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -225,6 +225,7 @@ static struct acpi_driver intel_menlow_memory_driver = {
 		.add = intel_menlow_memory_add,
 		.remove = intel_menlow_memory_remove,
 		},
+	.owner = THIS_MODULE,
 };
 
 /*
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index cc1e0ba..92fec38 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -199,6 +199,7 @@ static struct acpi_driver acpi_pcc_driver = {
 				.resume =       acpi_pcc_hotkey_resume,
 				.notify =	acpi_pcc_hotkey_notify,
 			},
+	.owner =	THIS_MODULE,
 };
 
 static const struct key_entry panasonic_keymap[] = {
diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index 1d07d6d..3b12bc6 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -184,6 +184,7 @@ static struct acpi_driver acpi_topstar_driver = {
 		.remove = acpi_topstar_remove,
 		.notify = acpi_topstar_notify,
 	},
+	.owner = THIS_MODULE,
 };
 
 static int __init topstar_laptop_init(void)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 05cc796..754117d 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -111,6 +111,7 @@ static struct acpi_driver acpi_wmi_driver = {
 		.remove = acpi_wmi_remove,
 		.notify = acpi_wmi_notify,
 	},
+	.owner = THIS_MODULE,
 };
 
 /*
diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index c1372ed..5639837 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -164,6 +164,7 @@ static struct acpi_driver xo15_ebook_driver = {
 		.remove = ebook_switch_remove,
 		.notify = ebook_switch_notify,
 	},
+	.owner = THIS_MODULE,
 };
 
 static int __init xo15_ebook_init(void)
-- 
1.7.2



