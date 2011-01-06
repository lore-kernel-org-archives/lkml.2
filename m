Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1AFWoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:44:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab1AFWn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:43:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 7/11] ACPI / PM: Rename acpi_power_off_device()
Date: Thu, 6 Jan 2011 23:38:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201101062331.17079.rjw@sisk.pl>
In-Reply-To: <201101062331.17079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062338.04737.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Rename acpi_power_off_device() to acpi_power_off() in analogy with
acpi_power_on().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/power.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -219,7 +219,7 @@ static int acpi_power_on(acpi_handle han
 	return result;
 }
 
-static int acpi_power_off_device(acpi_handle handle)
+static int acpi_power_off(acpi_handle handle)
 {
 	int result = 0;
 	acpi_status status = AE_OK;
@@ -268,7 +268,7 @@ static void __acpi_power_off_list(struct
 	int i;
 
 	for (i = num_res - 1; i >= 0 ; i--)
-		acpi_power_off_device(list->handles[i]);
+		acpi_power_off(list->handles[i]);
 }
 
 static void acpi_power_off_list(struct acpi_handle_list *list)
@@ -430,8 +430,7 @@ int acpi_disable_wakeup_device_power(str
 
 	/* Close power resource */
 	for (i = 0; i < dev->wakeup.resources.count; i++) {
-		int ret = acpi_power_off_device(
-				dev->wakeup.resources.handles[i]);
+		int ret = acpi_power_off(dev->wakeup.resources.handles[i]);
 		if (ret) {
 			printk(KERN_ERR PREFIX "Transition power state\n");
 			dev->wakeup.flags.valid = 0;

