Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2GYRoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:44:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:45456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2GYRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/19] perf hists: Print newline between hists callchains
Date: Wed, 25 Jul 2012 14:41:24 -0300
Message-Id: <1343238094-12481-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Tiny cosmetic fix. The lack of a newline between hists callchains was
looking slightly messy.

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
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1342631456-7233-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.1

