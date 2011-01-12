Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1ALLhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:37:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:41181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1ALLhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:37:13 -0500
Date: Wed, 12 Jan 2011 11:36:49 GMT
From: tip-bot for Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, torvalds@linux-foundation.org, tony.luck@intel.com,
        bjorn.helgaas@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org, tony.luck@intel.com,
        bjorn.helgaas@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        len.brown@intel.com, mingo@elte.hu
In-Reply-To: <4D2D6B5D.4080208@kernel.org>
References: <4D2D6B5D.4080208@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, ia64, acpi: Clean up x86-ism in drivers/acpi/numa.c
Message-ID: <tip-9378b63ccb32b9c071dab155c96357ad1e52a709@git.kernel.org>
Git-Commit-ID: 9378b63ccb32b9c071dab155c96357ad1e52a709
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 11:36:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9378b63ccb32b9c071dab155c96357ad1e52a709
Gitweb:     http://git.kernel.org/tip/9378b63ccb32b9c071dab155c96357ad1e52a709
Author:     Tony Luck <tony.luck@intel.com>
AuthorDate: Wed, 12 Jan 2011 00:50:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 12 Jan 2011 12:15:09 +0100

x86, ia64, acpi: Clean up x86-ism in drivers/acpi/numa.c

As pointed out by Linus CONFIG_X86 in drivers/acpi/numa.c is
ugly.

Builds and boots on ia64 (both normally and with maxcpus=8 to limit
the number of cpus).

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <4D2D6B5D.4080208@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/numa.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

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
