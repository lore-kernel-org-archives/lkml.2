Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2JXKIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:08:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JXKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:08:03 -0400
Date: Wed, 24 Oct 2012 03:06:34 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-20550a434583c78f8ff9a2819639e2bacbe58574@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        vincent.weaver@maine.edu, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, vincent.weaver@maine.edu, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349873598-12583-6-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add hardware events translations for Intel P6 cpus
Git-Commit-ID: 20550a434583c78f8ff9a2819639e2bacbe58574
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:06:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20550a434583c78f8ff9a2819639e2bacbe58574
Gitweb:     http://git.kernel.org/tip/20550a434583c78f8ff9a2819639e2bacbe58574
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:25 +0200

perf/x86: Add hardware events translations for Intel P6 cpus

Add support for Intel P6 processors to display 'events' sysfs
directory (/sys/devices/cpu/events/) with hw event translations:

  # ls /sys/devices/cpu/events/
  branch-instructions
  branch-misses
  bus-cycles
  cache-misses
  cache-references
  cpu-cycles
  instructions
  ref-cycles
  stalled-cycles-backend
  stalled-cycles-frontend

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-6-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h    |    1 +
 arch/x86/kernel/cpu/perf_event_p6.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 21419b9..115c1ea 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -539,6 +539,7 @@ static inline void set_linear_ip(struct pt_regs *regs, unsigned long ip)
 }
 
 ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event);
+ssize_t intel_event_sysfs_show(char *page, u64 config);
 
 #ifdef CONFIG_CPU_SUP_AMD
 
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index e4dd0f7..900b76b 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -134,6 +134,8 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.event_constraints	= p6_event_constraints,
 
 	.format_attrs		= intel_p6_formats_attr,
+	.events_sysfs_show	= intel_event_sysfs_show,
+
 };
 
 __init int p6_pmu_init(void)
