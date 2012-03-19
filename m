Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2CSPW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:22:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2CSPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:22:54 -0400
Date: Mon, 19 Mar 2012 08:22:25 -0700
From: tip-bot for Steffen Persvold <sp@numascale.com>
Message-ID: <tip-943bc7e110f269f88dc92bbf249adbd384d35f1c@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, sp@numascale.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, sp@numascale.com
In-Reply-To: <1331810188-24785-1-git-send-email-sp@numascale.com>
References: <1331810188-24785-1-git-send-email-sp@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Fix section warnings
Git-Commit-ID: 943bc7e110f269f88dc92bbf249adbd384d35f1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 08:22:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  943bc7e110f269f88dc92bbf249adbd384d35f1c
Gitweb:     http://git.kernel.org/tip/943bc7e110f269f88dc92bbf249adbd384d35f1c
Author:     Steffen Persvold <sp@numascale.com>
AuthorDate: Thu, 15 Mar 2012 12:16:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 19 Mar 2012 12:01:01 +0100

x86: Fix section warnings

Fix the following section warnings :

WARNING: vmlinux.o(.text+0x49dbc): Section mismatch in reference
from the function acpi_map_cpu2node() to the variable
.cpuinit.data:__apicid_to_node The function acpi_map_cpu2node()
references the variable __cpuinitdata __apicid_to_node. This is
often because acpi_map_cpu2node lacks a __cpuinitdata
annotation or the annotation of __apicid_to_node is wrong.

WARNING: vmlinux.o(.text+0x49dc1): Section mismatch in reference
from the function acpi_map_cpu2node() to the function
.cpuinit.text:numa_set_node() The function acpi_map_cpu2node()
references the function __cpuinit numa_set_node(). This is often
because acpi_map_cpu2node lacks a __cpuinit  annotation or the
annotation of numa_set_node is wrong.

WARNING: vmlinux.o(.text+0x526e77): Section mismatch in
reference from the function prealloc_protection_domains() to the
function .init.text:alloc_passthrough_domain() The function
prealloc_protection_domains() references the function __init
alloc_passthrough_domain(). This is often because
prealloc_protection_domains lacks a __init  annotation or the annotation of alloc_passthrough_domain is wrong.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Link: http://lkml.kernel.org/r/1331810188-24785-1-git-send-email-sp@numascale.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
