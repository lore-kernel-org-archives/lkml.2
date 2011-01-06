Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1AFXsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:48:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:27585 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1AFXsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:48:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,285,1291622400"; 
   d="scan'208";a="875209671"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Wu Fengguang" <fengguang.wu@intel.com>,
        "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
        "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
In-Reply-To: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
Date: Thu, 06 Jan 2011 15:48:20 -0800
Message-Id: <4d2654c410489a1b90@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested on X86.  Builds and boots on ia64 (both normally and with
maxcpus=8 to limit the number of cpus).

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

I left the comment ... though it might need some tweaking as it is
kind of tenuously connected to the '0' argument passed to acpi_table_parse_srat.

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index d9926af..5eb25eb 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -275,23 +275,19 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
-	int nr_cpu_entries = nr_cpu_ids;
 
-#ifdef CONFIG_X86
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
 	 * So go over all cpu entries in SRAT to get apicid to node mapping.
 	 */
-	nr_cpu_entries = MAX_LOCAL_APIC;
-#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_entries);
+				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_entries);
+				     acpi_parse_processor_affinity, 0);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
