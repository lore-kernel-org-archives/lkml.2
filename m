Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GPSwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 14:52:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1GPSwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 14:52:07 -0400
Date: Sat, 16 Jul 2011 18:52:00 GMT
From: tip-bot for Len Brown <len.brown@intel.com>
Message-ID: <tip-17edf2d79f1ea6dfdb4c444801d928953b9f98d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        table@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        table@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
In-Reply-To: <alpine.LFD.2.02.1107151732480.18606@x980>
References: <alpine.LFD.2.02.1107151732480.18606@x980>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message
Git-Commit-ID: 17edf2d79f1ea6dfdb4c444801d928953b9f98d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jul 2011 18:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17edf2d79f1ea6dfdb4c444801d928953b9f98d6
Gitweb:     http://git.kernel.org/tip/17edf2d79f1ea6dfdb4c444801d928953b9f98d6
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Fri, 15 Jul 2011 17:37:15 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 15 Jul 2011 15:13:55 -0700

x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message

Fix the printk_once() so that it actually prints (didn't print before
due to a stray comma.)

[ hpa: changed to an incremental patch and adjusted the description
  accordingly. ]

Signed-off-by: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1107151732480.18606@x980
Cc: <table@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index da0d779..ed6086e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -465,11 +465,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		u64 epb;
 
 		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
-		if ((epb & 0xF) == 0) {
-			printk_once(KERN_WARNING, "x86: updated energy_perf_bias"
-				" to 'normal' from 'performance'\n"
-				"You can view and update epb via utility,"
-				" such as x86_energy_perf_policy(8)\n");
+		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
+			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+				" Set to 'normal', was 'performance'\n"
+				"ENERGY_PERF_BIAS: View and update with"
+				" x86_energy_perf_policy(8)\n");
 			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}
