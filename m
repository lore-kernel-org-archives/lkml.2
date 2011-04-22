Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1DVMTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:19:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:56075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1DVMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:19:09 -0400
Date: Fri, 22 Apr 2011 12:18:46 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Message-ID: <tip-103b3934817a7c42fba6e1ef76ecb390a2837d40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, gorcunov@gmail.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, gorcunov@gmail.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1303398203-2918-2-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU -- Use perf_sample_data_init helper
Git-Commit-ID: 103b3934817a7c42fba6e1ef76ecb390a2837d40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:18:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  103b3934817a7c42fba6e1ef76ecb390a2837d40
Gitweb:     http://git.kernel.org/tip/103b3934817a7c42fba6e1ef76ecb390a2837d40
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 21 Apr 2011 11:03:20 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 10:20:04 +0200

perf, x86: P4 PMU -- Use perf_sample_data_init helper

Instead of opencoded assignments better to use
perf_sample_data_init helper.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Link: http://lkml.kernel.org/r/1303398203-2918-2-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 8ff882f..ae31e96 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
