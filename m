Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0JAHjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:39:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37048 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0JAHjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:39:20 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 3/9] ideapad: make sure we bind on the correct device
Date: Fri,  1 Oct 2010 15:39:14 +0800
Message-Id: <1285918754-12942-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading from method _CFG to make sure we bind on the correct VPC2004 device.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 15d7e7e..9face93 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -326,10 +326,13 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int i;
+	int i, cfg;
 	int devs_present[5];
 	struct ideapad_private *priv;
 
+	if (read_method_int(adevice->handle, "_CFG", &cfg))
+		return -ENODEV;
+
 	for (i = IDEAPAD_DEV_CAMERA; i < IDEAPAD_DEV_KILLSW; i++) {
 		devs_present[i] = ideapad_dev_exists(i);
 		if (devs_present[i] < 0)
-- 
1.7.1

