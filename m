Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1EYVfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:35:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:52326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1EYVfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:35:01 -0400
Date: Wed, 25 May 2011 21:34:51 GMT
From: tip-bot for Nikhil P Rao <nikhil.rao@intel.com>
Message-ID: <tip-8b27f2ff7a24f0735c96055e676872f05398d99b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nikhil.rao@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nikhil.rao@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306343921.19325.1.camel@fedora13>
References: <1306343921.19325.1.camel@fedora13>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove unnecessary check in detect_ht()
Git-Commit-ID: 8b27f2ff7a24f0735c96055e676872f05398d99b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 May 2011 21:34:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b27f2ff7a24f0735c96055e676872f05398d99b
Gitweb:     http://git.kernel.org/tip/8b27f2ff7a24f0735c96055e676872f05398d99b
Author:     Nikhil P Rao <nikhil.rao@intel.com>
AuthorDate: Wed, 25 May 2011 10:18:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 May 2011 23:01:08 +0200

x86: Remove unnecessary check in detect_ht()

This patch removes a check that causes incorrect scheduler
domain setup (SMP instead of SMT) and bootlog warning messages
when cpuid extensions for topology enumeration are not supported
and the number of processors reported to the OS is smaller than
smp_num_siblings.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Link: http://lkml.kernel.org/r/1306343921.19325.1.camel@fedora13
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c8b4162..53f02f5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -477,13 +477,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	if (smp_num_siblings <= 1)
 		goto out;
 
-	if (smp_num_siblings > nr_cpu_ids) {
-		pr_warning("CPU: Unsupported number of siblings %d",
-			   smp_num_siblings);
-		smp_num_siblings = 1;
-		return;
-	}
-
 	index_msb = get_count_order(smp_num_siblings);
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
 
