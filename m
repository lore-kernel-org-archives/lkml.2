Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0CRVNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:13:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26722 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0CRVM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HcMq/qzOnHgzzap3ThJ9imOU1uE35bS3SWOH2s4C1t4vVdyLqoeZqvK5jA5IN9KS1Y
         +bUcepyLy+bwSosPzKWXqP6SInAnFH9i4fTkVWkSWU9ldq2NlYX2a6ZzjkiRPwwnx99D
         WG5le5PVNEUxUQRf6ujLdDIMFlFXvqIOiPCLM=
Date: Fri, 19 Mar 2010 00:12:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86, perf: A few cosmetic dabs for p4 pmu (comments
	and constantify)
Message-ID: <20100318211256.GH5062@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- A few ESCR have escaped fixing at previous attempt.
- p4_escr_map is read only, make it const.

Nothing serious.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

| commit f53d69aedd592348e9f862c429f8fc99159ac7fc
| Merge: f10893e cb7d6b5
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Thu Mar 18 17:04:39 2010 +0100
|
|    Merge branch 'perf/core'

 arch/x86/include/asm/perf_event_p4.h |    4 ++--
 arch/x86/kernel/cpu/perf_event_p4.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -401,13 +401,13 @@ static inline u32 p4_default_escr_conf(i
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
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -545,7 +545,7 @@ static void p4_pmu_swap_config_ts(struct
 }
 
 /* ESCRs are not sequential in memory so we need a map */
-static unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
+static const unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
 	MSR_P4_ALF_ESCR0,	/*  0 */
 	MSR_P4_ALF_ESCR1,	/*  1 */
 	MSR_P4_BPU_ESCR0,	/*  2 */
