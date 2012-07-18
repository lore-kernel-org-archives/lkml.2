Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2GRRLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:11:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51649 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2GRRLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:11:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] perf tools: Print newline between hists callchains
Date: Wed, 18 Jul 2012 19:10:56 +0200
Message-Id: <1342631456-7233-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
References: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiny cosmetic fix. The lack of a newline between hists callchains
was looking slightly messy.

Before:

     0.24%      swapper  [kernel.kallsyms]  [k] _raw_spin_lock_irq
                |
                --- _raw_spin_lock_irq
                    run_timer_softirq
                    __do_softirq
                    call_softirq
                    do_softirq
                    irq_exit
                    smp_apic_timer_interrupt
                    apic_timer_interrupt
                    default_idle
                    amd_e400_idle
                    cpu_idle
                    start_secondary
     0.10%         perf  [kernel.kallsyms]  [k] lock_is_held
                   |
                   --- lock_is_held
                       __might_sleep
                       mutex_lock_nested
                       perf_event_for_each_child
                       perf_ioctl
                       do_vfs_ioctl
                       sys_ioctl
                       system_call_fastpath
                       ioctl
                       cmd_record
                       run_builtin
                       main
                       __libc_start_main

After:

     0.24%      swapper  [kernel.kallsyms]  [k] _raw_spin_lock_irq
                |
                --- _raw_spin_lock_irq
                    run_timer_softirq
                    __do_softirq
                    call_softirq
                    do_softirq
                    irq_exit
                    smp_apic_timer_interrupt
                    apic_timer_interrupt
                    default_idle
                    amd_e400_idle
                    cpu_idle
                    start_secondary

     0.10%         perf  [kernel.kallsyms]  [k] lock_is_held
                   |
                   --- lock_is_held
                       __might_sleep
                       mutex_lock_nested
                       perf_event_for_each_child
                       perf_ioctl
                       do_vfs_ioctl
                       sys_ioctl
                       system_call_fastpath
                       ioctl
                       cmd_record
                       run_builtin
                       main
                       __libc_start_main

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/hist.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 90dc35a..f247ef2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -749,6 +749,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 
 	ret += __callchain__fprintf_graph(fp, root, total_samples,
 					  1, 1, left_margin);
+	ret += fprintf(fp, "\n");
+
 	return ret;
 }
 
-- 
1.7.5.4

