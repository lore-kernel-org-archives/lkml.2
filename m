Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2H0ROx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2H0ROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:14:49 -0400
Date: Mon, 27 Aug 2012 10:14:38 -0700
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-b697a3b370bbce64eb80bd5c328e6964d7d4d03b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345916488-8355-10-git-send-email-fenghua.yu@intel.com>
References: <1345916488-8355-10-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug: During CPU0 online,
  enable x2apic, set_numa_node.
Git-Commit-ID: b697a3b370bbce64eb80bd5c328e6964d7d4d03b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:14:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b697a3b370bbce64eb80bd5c328e6964d7d4d03b
Gitweb:     http://git.kernel.org/tip/b697a3b370bbce64eb80bd5c328e6964d7d4d03b
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Sat, 25 Aug 2012 10:41:25 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 25 Aug 2012 19:26:34 -0700

x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.

Previously these functions were not run on the BSP (CPU 0, the boot processor)
since the boot processor init would only be executed before this functionality
was initialized.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1345916488-8355-10-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..a5b831e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1224,7 +1224,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
+	if (this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1256,8 +1256,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
