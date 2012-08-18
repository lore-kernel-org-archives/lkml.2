Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2HRRcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2HRRa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354045"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/31] sections: Fix section conflicts in arch/x86
Date: Sat, 18 Aug 2012 10:30:01 -0700
Message-Id: <1345311022-26328-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/apic.h          |    2 +-
 arch/x86/kernel/apic/apic_numachip.c |    4 ++--
 arch/x86/kernel/rtc.c                |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f342612..3388034 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -409,7 +409,7 @@ extern struct apic *apic;
  * to enforce the order with in them.
  */
 #define apic_driver(sym)					\
-	static struct apic *__apicdrivers_##sym __used		\
+	static const struct apic *__apicdrivers_##sym __used		\
 	__aligned(sizeof(struct apic *))			\
 	__section(.apicdrivers) = { &sym }
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index bc552cf..a65829a 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -30,7 +30,7 @@
 
 static int numachip_system __read_mostly;
 
-static struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip __read_mostly;
 
 static unsigned int get_apic_id(unsigned long x)
 {
@@ -199,7 +199,7 @@ static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static struct apic apic_numachip __refconst = {
+static const struct apic apic_numachip __refconst = {
 
 	.name				= "NumaConnect system",
 	.probe				= numachip_probe,
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index af6db6e..4929c1b 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -225,7 +225,7 @@ static struct platform_device rtc_device = {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char *ids[] __initconst =
+	static const char * const  const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
-- 
1.7.7.6

