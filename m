Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab2KNWfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:35:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab2KNWfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:35:00 -0500
Date: Wed, 14 Nov 2012 13:31:08 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-27ac537ab4c7f9675e93d1fa73df5f8f233b871d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-11-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-11-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug: During CPU0 online,
  enable x2apic, set_numa_node.
Git-Commit-ID: 27ac537ab4c7f9675e93d1fa73df5f8f233b871d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:34:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27ac537ab4c7f9675e93d1fa73df5f8f233b871d
Gitweb:     http://git.kernel.org/tip/27ac537ab4c7f9675e93d1fa73df5f8f233b871d
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:47 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:54 -0800

x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.

Previously these functions were not run on the BSP (CPU 0, the boot processor)
since the boot processor init would only be executed before this functionality
was initialized.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-11-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7505f7b..ca165ac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1237,7 +1237,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
+	if (this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1269,8 +1269,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
