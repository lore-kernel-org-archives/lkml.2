Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab0FJLOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:14:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab0FJLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:44 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/23] x86: fix set but not read variables
Message-Id: <20100610111043.08543B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some dead code, no real bugs.

Found by gcc 4.6 -Wall

Cc: x86@kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/aperture_64.c      |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.35-rc2-gcc/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6.35-rc2-gcc/arch/x86/kernel/cpu/mtrr/generic.c
@@ -433,13 +433,12 @@ static void generic_get_mtrr(unsigned in
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
 
Index: linux-2.6.35-rc2-gcc/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6.35-rc2-gcc/arch/x86/kernel/aperture_64.c
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
