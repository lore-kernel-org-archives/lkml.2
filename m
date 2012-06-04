Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2FDFnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:43:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2FDFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:30 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 08/15] acpi_video: fix leaking PCI references
Date: Mon,  4 Jun 2012 01:39:59 -0400
Message-Id: <cfb46f433a4da97c31780e08a259fac2cb6bd61f.1338786831.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 9577b6f..66e8f73 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1745,6 +1745,7 @@ static int acpi_video_bus_remove(struct acpi_device *device, int type)
 
 static int __init intel_opregion_present(void)
 {
+	int i915 = 0;
 #if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
 	struct pci_dev *dev = NULL;
 	u32 address;
@@ -1757,10 +1758,10 @@ static int __init intel_opregion_present(void)
 		pci_read_config_dword(dev, 0xfc, &address);
 		if (!address)
 			continue;
-		return 1;
+		i915 = 1;
 	}
 #endif
-	return 0;
+	return i915;
 }
 
 int acpi_video_register(void)
-- 
1.7.11.rc0.100.g5498c5f

