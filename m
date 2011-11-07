Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1KGXXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab1KGXXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:23:42 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 2/4] ACPI: Export interfaces for ioremapping/iounmapping
	ACPI registers
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 16:23:34 -0700
Message-ID: <20111107232334.13472.6680.stgit@amt.stowe>
In-Reply-To: <20111107232321.13472.52069.stgit@amt.stowe>
References: <20111107232321.13472.52069.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

