Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab2JXM7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:59:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2JXM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:59:41 -0400
Date: Wed, 24 Oct 2012 05:58:24 -0700
From: tip-bot for Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Message-ID: <tip-64dfab8e83644902ad2fd559a56c411b47e3ef3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zheng.z.yan@intel.com, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de
In-Reply-To: <CAPgLHd8NZkYSkZm22FpZxiEh6HcA0q-V=29vdnheiDhgrJZ+yw@mail.gmail.com>
References: <CAPgLHd8NZkYSkZm22FpZxiEh6HcA0q-V=29vdnheiDhgrJZ+yw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Remove unused variable in nhmex_rbox_alter_er()
Git-Commit-ID: 64dfab8e83644902ad2fd559a56c411b47e3ef3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 05:58:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64dfab8e83644902ad2fd559a56c411b47e3ef3c
Gitweb:     http://git.kernel.org/tip/64dfab8e83644902ad2fd559a56c411b47e3ef3c
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Mon, 22 Oct 2012 16:51:38 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:51:40 +0200

perf/x86: Remove unused variable in nhmex_rbox_alter_er()

The variable port is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/CAPgLHd8NZkYSkZm22FpZxiEh6HcA0q-V%3D29vdnheiDhgrJZ%2Byw@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 6f87477..3cf3d97 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1558,7 +1558,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-	int port;
 
 	/* adjust the main event selector and extra register index */
 	if (reg1->idx % 2) {
@@ -1570,7 +1569,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 	}
 
 	/* adjust extra register config */
-	port = reg1->idx / 6 + box->pmu->pmu_idx * 4;
 	switch (reg1->idx % 6) {
 	case 2:
 		/* shift the 8~15 bits to the 0~7 bits */
