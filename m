Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2KWQcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:32:12 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60715 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2KWQcK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Nov 2012 11:32:10 -0500
Message-Id: <50AFB35102000078000AAECA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 23 Nov 2012 16:33:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: convert a few mistaken __cpuinit annotations to
 __init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two are functions serving as initcalls; the SFI one is only
being called from __init code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 arch/x86/mm/tlb.c                     |    2 +-
 arch/x86/platform/sfi/sfi.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- 3.7-rc6/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 3.7-rc6-x86-sections/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1192,7 +1192,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
--- 3.7-rc6/arch/x86/mm/tlb.c
+++ 3.7-rc6-x86-sections/arch/x86/mm/tlb.c
@@ -335,7 +335,7 @@ static const struct file_operations fops
 	.llseek = default_llseek,
 };
 
-static int __cpuinit create_tlb_flushall_shift(void)
+static int __init create_tlb_flushall_shift(void)
 {
 	if (cpu_has_invlpg) {
 		debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
--- 3.7-rc6/arch/x86/platform/sfi/sfi.c
+++ 3.7-rc6-x86-sections/arch/x86/platform/sfi/sfi.c
@@ -35,7 +35,7 @@
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
 /* All CPUs enumerated by SFI must be present and enabled */
-static void __cpuinit mp_sfi_register_lapic(u8 id)
+static void __init mp_sfi_register_lapic(u8 id)
 {
 	if (MAX_LOCAL_APIC - id <= 0) {
 		pr_warning("Processor #%d invalid (max %d)\n",



