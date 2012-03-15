Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817Ab2COLQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:16:39 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:37470 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2COLQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:16:38 -0400
From: Steffen Persvold <sp@numascale.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH] Fix section warnings
Date: Thu, 15 Mar 2012 12:16:28 +0100
Message-Id: <1331810188-24785-1-git-send-email-sp@numascale.com>
X-Mailer: git-send-email 1.7.4.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section warnings :

WARNING: vmlinux.o(.text+0x49dbc): Section mismatch in reference from the function acpi_map_cpu2node() to the variable .cpuinit.data:__apicid_to_node
The function acpi_map_cpu2node() references
the variable __cpuinitdata __apicid_to_node.
This is often because acpi_map_cpu2node lacks a __cpuinitdata 
annotation or the annotation of __apicid_to_node is wrong.

WARNING: vmlinux.o(.text+0x49dc1): Section mismatch in reference from the function acpi_map_cpu2node() to the function .cpuinit.text:numa_set_node()
The function acpi_map_cpu2node() references
the function __cpuinit numa_set_node().
This is often because acpi_map_cpu2node lacks a __cpuinit 
annotation or the annotation of numa_set_node is wrong.

WARNING: vmlinux.o(.text+0x526e77): Section mismatch in reference from the function prealloc_protection_domains() to the function .init.text:alloc_passthrough_domain()
The function prealloc_protection_domains() references
the function __init alloc_passthrough_domain().
This is often because prealloc_protection_domains lacks a __init 
annotation or the annotation of alloc_passthrough_domain is wrong.

Signed-off-by: Steffen Persvold <sp@numascale.com>

---
 arch/x86/kernel/acpi/boot.c |    2 +-
 drivers/iommu/amd_iommu.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ce664f3..406ed77 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -593,7 +593,7 @@ void __init acpi_set_irq_model_ioapic(void)
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinitdata acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f75e060..ae2ec92 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2804,7 +2804,7 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
  */
-static void prealloc_protection_domains(void)
+static void __init prealloc_protection_domains(void)
 {
 	struct iommu_dev_data *dev_data;
 	struct dma_ops_domain *dma_dom;
-- 
1.7.4.1

