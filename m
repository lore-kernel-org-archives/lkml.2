Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1AWNh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:37:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1AWNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Eh9LSaPj6WKlVkdVdYJV5jm+vea4MTtBs329Uxu294alaf4zpxT8DeLRYNU0o43LPg
         A3DgybsmJktQL5VCrNQ8xHcb33w8JnbJhGoVZMJGApWmaZ9tY7TQ8cgtCpiST1XN6QIN
         E1UHX6unGvql3F32BxTRBqDVTLjzNj/gjFH9c=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, penberg@kernel.org, shaohui.zheng@intel.com,
        rientjes@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] x86: Kill unused static boot_cpu_logical_apicid in smpboot.c
Date: Sun, 23 Jan 2011 14:37:27 +0100
Message-Id: <1295789862-25482-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295789862-25482-1-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/kernel/smpboot.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763df77..c255980 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -165,8 +165,6 @@ static void unmap_cpu_to_node(int cpu)
 #endif
 
 #ifdef CONFIG_X86_32
-static int boot_cpu_logical_apicid;
-
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
@@ -1096,9 +1094,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
-#ifdef CONFIG_X86_32
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-#endif
+
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-- 
1.7.1

