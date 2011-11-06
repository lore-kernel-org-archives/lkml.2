Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1KFNSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:18:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1KFNSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:18:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [Resend 2x] ACPI: Drop ACPI_NO_HARDWARE_INIT
Date: Sun, 6 Nov 2011 14:20:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Len Brown (Intel)" <len.brown@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111061420.43158.rjw@sisk.pl>
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
@@ -911,10 +911,7 @@ void __init acpi_early_init(void)
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
@@ -935,8 +932,7 @@ static int __init acpi_bus_init(void)
 
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
