Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0ERJaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:30:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:62722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0ERJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:30:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,254,1272870000"; 
   d="scan'208";a="568172732"
Subject: [PATCH] x86,perf: P4 PMU -- fix misprint in unflagged nmi handling
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 May 2010 17:29:14 +0800
Message-Id: <1274174954.22793.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] x86,perf: P4 PMU -- fix misprint in unflagged nmi handling

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index f44ce8d..e695795 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -473,7 +473,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	rdmsr(hwc->config_base + hwc->idx, low, high);
 
 	/* we need to check high bit for unflagged overflows */
-	if ((low & P4_CCCR_OVF) || (high & (1 << 31))) {
+	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
 		overflow = 1;
 		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
 			((u64)low) & ~P4_CCCR_OVF);


