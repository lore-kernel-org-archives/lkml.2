Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1CZLam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:30:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1CZLal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:30:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Drop ACPI_NO_HARDWARE_INIT
Date: Sat, 26 Mar 2011 12:30:59 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103261231.00094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI_NO_HARDWARE_INIT is only used by acpi_early_init() and
acpi_bus_init() when calling acpi_enable_subsystem(), but
acpi_enable_subsystem() doesn't check that flag, so it can be
dropped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c     |    8 ++------
 include/acpi/actypes.h |    1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -901,10 +901,7 @@ void __init acpi_early_init(void)
 	}
 #endif
 
-	status =
-	    acpi_enable_subsystem(~
-				  (ACPI_NO_HARDWARE_INIT |
-				   ACPI_NO_ACPI_ENABLE));
+	status = acpi_enable_subsystem(~ACPI_NO_ACPI_ENABLE);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX "Unable to enable ACPI\n");
 		goto error0;
@@ -925,8 +922,7 @@ static int __init acpi_bus_init(void)
 
 	acpi_os_initialize1();
 
-	status =
-	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
+	status = acpi_enable_subsystem(ACPI_NO_ACPI_ENABLE);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX
 		       "Unable to start the ACPI Interpreter\n");
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -470,7 +470,6 @@ typedef u64 acpi_integer;
  */
 #define ACPI_FULL_INITIALIZATION        0x00
 #define ACPI_NO_ADDRESS_SPACE_INIT      0x01
-#define ACPI_NO_HARDWARE_INIT           0x02
 #define ACPI_NO_EVENT_INIT              0x04
 #define ACPI_NO_HANDLER_INIT            0x08
 #define ACPI_NO_ACPI_ENABLE             0x10
