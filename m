Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab2HCE3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:29:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2HCE3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:29:50 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        mjg@redhat.com, ibm-acpi@hmh.eng.br
Subject: [PATCH] thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR
Date: Thu,  2 Aug 2012 23:29:47 -0500
Message-Id: <1343968187-20930-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

In the latest V-series bios DMI_PRODUCT_VERSION does not contain
the string Lenovo or Thinkpad, but is set to the model number, this
causes the thinkpad_acpi module to fail to load. Recognize laptop
as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e7f7328..eec0b65 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8657,7 +8657,8 @@ static int __must_check __init get_thinkpad_model_data(
 		}
 	}
 
-	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
+	s = dmi_get_system_info(DMI_PRODUCT_VERSION) ?
+		dmi_get_system_info(DMI_BIOS_VENDOR) : NULL;
 	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
-- 
1.7.9.5

