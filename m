Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1JQPZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:25:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34630 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JQPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:25:35 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] x86, microcode: Correct microcode revision format
Date: Mon, 17 Oct 2011 17:25:14 +0200
Message-Id: <1318865115-9904-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1318865115-9904-1-git-send-email-bp@amd64.org>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

506ed6b53e00ba303ad778122f08e1fca7cf5efb added microcode revision format
to /proc/cpuinfo and the MCE handler in decimal format but both AMD and
Intel patch levels are handled as hex numbers. Fix it.

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 arch/x86/kernel/cpu/proc.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8af6fa4..ad8d897 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -221,7 +221,7 @@ static void print_mce(struct mce *m)
 	 * Note this output is parsed by external tools and old fields
 	 * should not be changed.
 	 */
-	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
 		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
 		cpu_data(m->extcpu).microcode);
 
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 6254fda..14b2314 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -86,7 +86,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	else
 		seq_printf(m, "stepping\t: unknown\n");
 	if (c->microcode)
-		seq_printf(m, "microcode\t: %u\n", c->microcode);
+		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
 
 	if (cpu_has(c, X86_FEATURE_TSC)) {
 		unsigned int freq = cpufreq_quick_get(cpu);
-- 
1.7.4.rc2

