Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0KXXRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:17:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab0KXXRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:17:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 12/13] ACPI / PM: Drop acpi_bus_get_power()
Date: Thu, 25 Nov 2010 00:12:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011250012.06151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There are no more users of acpi_bus_get_power(), so it can be
dropped.  Moreover, it should be dropped, because it modifies
the device->power.state field of an ACPI device without updating
the reference counters of the device's power resources, which is
wrong.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c      |   19 -------------------
 include/acpi/acpi_bus.h |    1 -
 2 files changed, 20 deletions(-)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -236,25 +236,6 @@ static int __acpi_bus_get_power(struct a
 }
 
 
-int acpi_bus_get_power(acpi_handle handle, int *state)
-{
-	struct acpi_device *device;
-	int result;
-
-	result = acpi_bus_get_device(handle, &device);
-	if (result)
-		return result;
-
-	result = __acpi_bus_get_power(device, state);
-	if (result)
-		return result;
-
-	device->power.state = *state;
-	return 0;
-}
-EXPORT_SYMBOL(acpi_bus_get_power);
-
-
 static int __acpi_bus_set_power(struct acpi_device *device, int state)
 {
 	int result = 0;
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -327,7 +327,6 @@ void acpi_bus_data_handler(acpi_handle h
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
-int acpi_bus_get_power(acpi_handle handle, int *state);
 int acpi_bus_set_power(acpi_handle handle, int state);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);

