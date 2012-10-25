Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab2JYJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:28:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2JYJ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:28:13 -0400
From: Ivan Hu <ivan.hu@canonical.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        alex.shi@intel.com, borislav.petkov@amd.com, ivan.hu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86, intel, power: Modify the MSR_IA32_ENERGY_PERF_BIAS message from warning to info
Date: Thu, 25 Oct 2012 17:28:00 +0800
Message-Id: <1351157280-9935-1-git-send-email-ivan.hu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel IA32 program guild doesn't mention that this MSR should be set by
BIOS, instead, it mentions "Software can use whatever criteria it sees
fit to program the MSR with the appropriate value.". Discuss with IBV,
they'd like to keep this MSR as default, and let OS to change value if desired.
This message should be more proper set as an info than a warning.

Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
---
 arch/x86/kernel/cpu/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 198e019..2bdc6bf 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -466,7 +466,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
-			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+			printk_once(KERN_INFO "ENERGY_PERF_BIAS:"
 				" Set to 'normal', was 'performance'\n"
 				"ENERGY_PERF_BIAS: View and update with"
 				" x86_energy_perf_policy(8)\n");
-- 
1.7.10.4

