Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2AQMWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:30 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:63457 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2AQMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:21 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 40/50] ACPI: Export interfaces for ioremapping/iounmapping ACPI
 registers
Date: Tue, 17 Jan 2012 07:21:32 -0500
Message-id: <6f68c91c55ea3576d366797fa8d45e31c4aa79f8.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

Export remapping and unmapping interfaces - acpi_os_map_generic_address()
and acpi_os_unmap_generic_address() - for ACPI generic registers that are
backed by memory mapped I/O (MMIO).

The acpi_os_map_generic_address() and acpi_os_unmap_generic_address()
declarations may more properly belong in include/acpi/acpiosxf.h next to
acpi_os_read_memory() but I believe that would require the ACPI CA making
them an official part of the ACPI CA - OS interface.

ACPI Generic Address Structure (GAS) reference (ACPI's fixed/generic
hardware registers use the GAS format):
  ACPI Specification, Revision 4.0, Section 5.2.3.1, "Generic Address
  Structure"

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/osl.c      |    6 ++++--
 include/linux/acpi_io.h |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 2e285cd..b11f267 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -431,7 +431,7 @@ void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 		__acpi_unmap_table(virt, size);
 }
 
-static int acpi_os_map_generic_address(struct acpi_generic_address *gas)
+int acpi_os_map_generic_address(struct acpi_generic_address *gas)
 {
 	u64 addr;
 	void __iomem *virt;
@@ -450,8 +450,9 @@ static int acpi_os_map_generic_address(struct acpi_generic_address *gas)
 
 	return 0;
 }
+EXPORT_SYMBOL(acpi_os_map_generic_address);
 
-static void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
+void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 {
 	u64 addr;
 	struct acpi_ioremap *map;
@@ -475,6 +476,7 @@ static void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 
 	acpi_os_map_cleanup(map);
 }
+EXPORT_SYMBOL(acpi_os_unmap_generic_address);
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
index 4afd710..b0ffa21 100644
--- a/include/linux/acpi_io.h
+++ b/include/linux/acpi_io.h
@@ -12,4 +12,7 @@ static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
 
 void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
 
+int acpi_os_map_generic_address(struct acpi_generic_address *addr);
+void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
+
 #endif
-- 
1.7.9.rc1

