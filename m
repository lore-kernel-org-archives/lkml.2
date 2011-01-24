Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AXXdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:33:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1AXXdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:33:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/8] ACPI: Do not export functions that are only used in osl.c
Date: Tue, 25 Jan 2011 00:27:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101250025.10817.rjw@sisk.pl>
In-Reply-To: <201101250025.10817.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201101250027.37509.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The functions acpi_os_map_generic_address() and
acpi_os_unmap_generic_address() are only used in drivers/acpi/osl.c,
so make them static and remove the extern definitions of them from
include/linux/acpi_io.h.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c      |    6 ++----
 include/linux/acpi_io.h |    3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -397,7 +397,7 @@ void __init early_acpi_os_unmap_memory(v
 		__acpi_unmap_table(virt, size);
 }
 
-int acpi_os_map_generic_address(struct acpi_generic_address *addr)
+static int acpi_os_map_generic_address(struct acpi_generic_address *addr)
 {
 	void __iomem *virt;
 
@@ -413,9 +413,8 @@ int acpi_os_map_generic_address(struct a
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(acpi_os_map_generic_address);
 
-void acpi_os_unmap_generic_address(struct acpi_generic_address *addr)
+static void acpi_os_unmap_generic_address(struct acpi_generic_address *addr)
 {
 	void __iomem *virt;
 	unsigned long flags;
@@ -433,7 +432,6 @@ void acpi_os_unmap_generic_address(struc
 
 	acpi_os_unmap_memory(virt, size);
 }
-EXPORT_SYMBOL_GPL(acpi_os_unmap_generic_address);
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
Index: linux-2.6/include/linux/acpi_io.h
===================================================================
--- linux-2.6.orig/include/linux/acpi_io.h
+++ linux-2.6/include/linux/acpi_io.h
@@ -10,7 +10,4 @@ static inline void __iomem *acpi_os_iore
        return ioremap_cache(phys, size);
 }
 
-int acpi_os_map_generic_address(struct acpi_generic_address *addr);
-void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
-
 #endif

