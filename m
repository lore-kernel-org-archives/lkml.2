Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1DUUE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab1DUUE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/4] perf, x86: P4 PMU -- Use perf_sample_data_init helper
Date: Thu, 21 Apr 2011 11:03:20 -0400
Message-Id: <1303398203-2918-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Instead of opencoded assignments better to use
perf_sample_data_init helper.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..6f2bd89 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-- 
1.7.4.2

