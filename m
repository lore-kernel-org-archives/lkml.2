Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0FIO2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:28:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:43680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab0FIO23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:28:29 -0400
Date: Wed, 9 Jun 2010 14:27:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mikey@neuling.org,
       mingo@elte.hu
In-Reply-To: <tip-76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00@git.kernel.org>
References: <tip-76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] powerpc: Exclude arch_sd_sibiling_asym_packing() on UP
Message-ID: <tip-00318f5eea0642c29212bff76ba500f620400d78@git.kernel.org>
Git-Commit-ID: 00318f5eea0642c29212bff76ba500f620400d78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 14:27:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00318f5eea0642c29212bff76ba500f620400d78
Gitweb:     http://git.kernel.org/tip/00318f5eea0642c29212bff76ba500f620400d78
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 9 Jun 2010 16:20:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 16:24:36 +0200

powerpc: Exclude arch_sd_sibiling_asym_packing() on UP

Only SMP systems care about load-balance features, plus this
saves some .text space on UP and also fixes the build.

Reported-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <tip-76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00@git.kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/process.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index a3f347c..9b41ece 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1269,6 +1269,7 @@ unsigned long randomize_et_dyn(unsigned long base)
 	return ret;
 }
 
+#ifdef CONFIG_SMP
 int arch_sd_sibiling_asym_packing(void)
 {
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
@@ -1277,3 +1278,4 @@ int arch_sd_sibiling_asym_packing(void)
 	}
 	return 0;
 }
+#endif
