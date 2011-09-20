Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1ITV4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:56:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1ITV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:56:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] toshiba_acpi: Initialize brightness in backlight device
Date: Tue, 20 Sep 2011 16:55:54 -0500
Message-Id: <1316555754-25949-7-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index c51a64c..13ef8c3 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -979,6 +979,7 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 		dev->backlight_dev = NULL;
 		goto error;
 	}
+	dev->backlight_dev->props.brightness = get_lcd(dev->backlight_dev);
 
 	/* Register rfkill switch for Bluetooth */
 	if (hci_get_bt_present(dev, &bt_present) == HCI_SUCCESS && bt_present) {
-- 
1.7.4.1

