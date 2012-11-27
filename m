Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2K0GfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:35:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2K0GfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:35:06 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 v7] AMD64 EDAC: Consistently use u16 for northbridge IDs in amd_get_nb_id
Date: Tue, 27 Nov 2012 14:32:10 +0800
Message-Id: <1353997932-8475-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change amd_get_nb_id to return u16 to support >255 memory controllers,
and related consistency fixes.

v7: Refactor patches grouping changes

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/amd.c        |    4 ++--
 drivers/edac/amd64_edac.c        |    5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..eb3ba58 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -934,7 +934,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-extern int amd_get_nb_id(int cpu);
+extern u16 amd_get_nb_id(int cpu);
 
 struct aperfmperf {
 	u64 aperf, mperf;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1b7d165..2e298e9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -364,9 +364,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
-int amd_get_nb_id(int cpu)
+u16 amd_get_nb_id(int cpu)
 {
-	int id = 0;
+	u16 id = 0;
 #ifdef CONFIG_SMP
 	id = per_cpu(cpu_llc_id, cpu);
 #endif
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9ba70a5..60e93fa 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -942,7 +942,8 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid;
+		u8 intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -2253,7 +2254,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 {
 	int cpu;
 
-- 
1.7.10.4

