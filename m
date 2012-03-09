Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2CIXcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:32:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2CIXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:32:35 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH] thinkpad-acpi: recognize Lenovo as version string in newer V-series BIOS
Date: Fri,  9 Mar 2012 17:32:24 -0600
Message-Id: <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com>
References: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newer V series bios reports product version as 'Lenovo'
instead of 'ThinkPad'. Recoginze this new string so that
the module can load.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index ea0c607..d68c000 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8658,7 +8658,7 @@ static int __must_check __init get_thinkpad_model_data(
 	}
 
 	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
-	if (s && !strnicmp(s, "ThinkPad", 8)) {
+	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
-- 
1.7.9.1

