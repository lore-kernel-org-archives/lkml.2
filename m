Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3ADAH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59165 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3ADAHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/12] ACPI / scan: Remove unnecessary initialization of local variables
Date: Fri, 04 Jan 2013 01:07:52 +0100
Message-ID: <11913672.0klWX8xjg6@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1418767.4KIZOTK1lk@vostro.rjw.lan>
References: <1418767.4KIZOTK1lk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The local variables in acpi_bus_get_power_flags() need not be
initialized upfront, so change the code accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1091,9 +1091,9 @@ static void acpi_bus_init_power_state(st
 
 static void acpi_bus_get_power_flags(struct acpi_device *device)
 {
-	acpi_status status = 0;
-	acpi_handle handle = NULL;
-	u32 i = 0;
+	acpi_status status;
+	acpi_handle handle;
+	u32 i;
 
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
 	status = acpi_get_handle(device->handle, "_PS0", &handle);

