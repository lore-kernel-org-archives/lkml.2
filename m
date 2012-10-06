Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2JFUOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:14:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52672 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2JFUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:14:14 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 14/49] usb-acpi: Comply with the ACPI API change
Date: Sat,  6 Oct 2012 16:09:35 -0400
Message-Id: <59e6423ba8aaa42289457a15ffc7d111a955a2fa.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

acpi_get_physical_device_location()'s 2nd argument has been changed
in ACPI implementaion, so need a follow-on change in
usb_acpi_check_pld().

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/usb/core/usb-acpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 8947b20..ce45f55 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -52,18 +52,19 @@ out:
 static int usb_acpi_check_pld(struct usb_device *udev, acpi_handle handle)
 {
 	acpi_status status;
-	struct acpi_pld pld;
+	struct acpi_pld_info *pld;
 
 	status = acpi_get_physical_device_location(handle, &pld);
 
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	if (pld.user_visible)
+	if (pld->user_visible)
 		udev->removable = USB_DEVICE_REMOVABLE;
 	else
 		udev->removable = USB_DEVICE_FIXED;
 
+	ACPI_FREE(pld);
 	return 0;
 }
 
-- 
1.8.0.rc0.18.gf84667d

