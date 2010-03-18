Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0CRWEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0CRWEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:04:33 -0400
Date: Thu, 18 Mar 2010 22:03:54 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20100318211256.GH5062@lenovo>
References: <20100318211256.GH5062@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Fix few cosmetic dabs for P4 pmu (comments and constantify)
Message-ID: <tip-9c8c6bad3137112d2c7bf3d215b736ee4215fa74@git.kernel.org>
Git-Commit-ID: 9c8c6bad3137112d2c7bf3d215b736ee4215fa74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 22:03:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c8c6bad3137112d2c7bf3d215b736ee4215fa74
Gitweb:     http://git.kernel.org/tip/9c8c6bad3137112d2c7bf3d215b736ee4215fa74
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Fri, 19 Mar 2010 00:12:56 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 22:17:46 +0100

x86, perf: Fix few cosmetic dabs for P4 pmu (comments and constantify)

- A few ESCR have escaped fixing at previous attempt.
- p4_escr_map is read only, make it const.

Nothing serious.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <20100318211256.GH5062@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event_p4.h |    4 ++--
 arch/x86/kernel/cpu/perf_event_p4.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 871249c..2a1a57f 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -401,13 +401,13 @@ static inline u32 p4_default_escr_conf(int cpu, int exclude_os, int exclude_usr)
 #define P4_RETIRED_MISPRED_BRANCH_TYPE	P4_EVENT_PACK(0x05, 0x02)
 	/*
 	 * MSR_P4_TBPU_ESCR0:	4, 5
-	 * MSR_P4_TBPU_ESCR0:	6, 7
+	 * MSR_P4_TBPU_ESCR1:	6, 7
 	 */
 
 #define P4_RETIRED_BRANCH_TYPE		P4_EVENT_PACK(0x04, 0x02)
 	/*
 	 * MSR_P4_TBPU_ESCR0:	4, 5
-	 * MSR_P4_TBPU_ESCR0:	6, 7
+	 * MSR_P4_TBPU_ESCR1:	6, 7
 	 */
 
 #define P4_RESOURCE_STALL		P4_EVENT_PACK(0x01, 0x01)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b7bf991..b8a811a 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -545,7 +545,7 @@ static void p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
 }
 
 /* ESCRs are not sequential in memory so we need a map */
-static unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
+static const unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
 	MSR_P4_ALF_ESCR0,	/*  0 */
 	MSR_P4_ALF_ESCR1,	/*  1 */
 	MSR_P4_BPU_ESCR0,	/*  2 */
