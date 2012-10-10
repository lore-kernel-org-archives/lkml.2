Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2JJMzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab2JJMyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf x86: Adding hardware events translations for p6 cpus
Date: Wed, 10 Oct 2012 14:53:15 +0200
Message-Id: <1349873598-12583-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for p6 processors to display 'events' sysfs
directory (/sys/devices/cpu/events/) with hw event translations.

  # ls  /sys/devices/cpu/events/
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
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_p6.c | 2 ++
 include/linux/perf_event.h          | 1 +
 2 files changed, 3 insertions(+)

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
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 827c374..6e48be0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1419,6 +1419,7 @@ _name##_show(struct device *dev,					\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
 ssize_t x86_event_sysfs_show(char *page, u64 config, u64 event);
+ssize_t intel_event_sysfs_show(char *page, u64 config);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
-- 
1.7.11.4

