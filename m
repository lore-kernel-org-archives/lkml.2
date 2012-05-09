Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2EIObv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:31:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2EIObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:31:49 -0400
Date: Wed, 9 May 2012 07:31:35 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-7bf352384fda3f678a283928c6c5b2cd9da877e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-4-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Enable ibs op micro-ops counting mode
Git-Commit-ID: 7bf352384fda3f678a283928c6c5b2cd9da877e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:31:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bf352384fda3f678a283928c6c5b2cd9da877e4
Gitweb:     http://git.kernel.org/tip/7bf352384fda3f678a283928c6c5b2cd9da877e4
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:12 +0200

perf/x86-ibs: Enable ibs op micro-ops counting mode

Allow enabling ibs op micro-ops counting mode.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-4-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 2317228..ebf169f 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -468,6 +468,8 @@ static __init int perf_event_ibs_init(void)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	if (ibs_caps & IBS_CAPS_OPCNT)
+		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
 	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
 	register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
