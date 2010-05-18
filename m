Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0EROzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab0EROzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:55:12 -0400
Date: Tue, 18 May 2010 14:54:37 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <1274174954.22793.17.camel@minggr.sh.intel.com>
References: <1274174954.22793.17.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU -- fix typo in unflagged NMI handling
Message-ID: <tip-ef4f30f54e265c2f6f9ac9eda4db158a4e16050b@git.kernel.org>
Git-Commit-ID: ef4f30f54e265c2f6f9ac9eda4db158a4e16050b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 14:54:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef4f30f54e265c2f6f9ac9eda4db158a4e16050b
Gitweb:     http://git.kernel.org/tip/ef4f30f54e265c2f6f9ac9eda4db158a4e16050b
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Tue, 18 May 2010 17:29:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 12:05:20 +0200

perf, x86: P4 PMU -- fix typo in unflagged NMI handling

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <1274174954.22793.17.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 02f0728..87e1803 100644
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
