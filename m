Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2LPN1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:27:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35378 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2LPN05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:26:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Do not apply ACPI_SUCCESS() to acpi_bus_get_device() result
Date: Sun, 16 Dec 2012 14:32:06 +0100
Message-ID: <1432424.eSUdEQ1VBT@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the return value of acpi_bus_get_device() is not of type
acpi_status, ACPI_SUCCESS() should not be used for checking its
return value.  Fix that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -358,8 +358,7 @@ static struct acpi_device *acpi_dev_pm_g
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 
-	return handle && ACPI_SUCCESS(acpi_bus_get_device(handle, &adev)) ?
-		adev : NULL;
+	return handle && !acpi_bus_get_device(handle, &adev) ? adev : NULL;
 }
 
 /**

