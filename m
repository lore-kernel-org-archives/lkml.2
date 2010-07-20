Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab0GTX4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:56:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab0GTX4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:56:05 -0400
Date: Tue, 20 Jul 2010 23:55:02 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201007202219.o6KMJnQ0021072@imap1.linux-foundation.org>
References: <201007202219.o6KMJnQ0021072@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/gcc46] x86, gcc-4.6: Fix set but not read variables
Message-ID: <tip-fa10ba64ac94fec4611b79804023eb087862ffe0@git.kernel.org>
Git-Commit-ID: fa10ba64ac94fec4611b79804023eb087862ffe0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 23:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa10ba64ac94fec4611b79804023eb087862ffe0
Gitweb:     http://git.kernel.org/tip/fa10ba64ac94fec4611b79804023eb087862ffe0
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Tue, 20 Jul 2010 15:19:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 15:38:30 -0700

x86, gcc-4.6: Fix set but not read variables

Just some dead code, no real bugs.

Found by gcc 4.6 -Wall

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <201007202219.o6KMJnQ0021072@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/aperture_64.c      |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b5d8b0b..a2e0caf 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -280,7 +280,7 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	u32 agp_aper_base = 0, agp_aper_order = 0;
+	u32 agp_aper_order = 0;
 	int i, fix, slot, valid_agp = 0;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
@@ -291,7 +291,7 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* This is mostly duplicate of iommu_hole_init */
-	agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+	search_agp_bridge(&agp_aper_order, &valid_agp);
 
 	fix = 0;
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index fd31a44..7d28d7d 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -433,13 +433,12 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
-	int cpu;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
 	 * from any cpu, so try to print it out directly.
 	 */
-	cpu = get_cpu();
+	get_cpu();
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
