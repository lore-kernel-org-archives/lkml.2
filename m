Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1AZHSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:18:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:55878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1AZHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:18:44 -0500
Date: Wed, 26 Jan 2011 07:18:11 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add missing cpu_map__delete()
Message-ID: <tip-915fce20ecf8f7ff4189d0fff42b62aebf6a57cc@git.kernel.org>
Git-Commit-ID: 915fce20ecf8f7ff4189d0fff42b62aebf6a57cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:18:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  915fce20ecf8f7ff4189d0fff42b62aebf6a57cc
Gitweb:     http://git.kernel.org/tip/915fce20ecf8f7ff4189d0fff42b62aebf6a57cc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Jan 2011 16:19:12 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:30 -0200

perf tools: Add missing cpu_map__delete()

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cpumap.c |    5 +++++
 tools/perf/util/cpumap.h |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 3ccaa10..6893eec 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -177,3 +177,8 @@ struct cpu_map *cpu_map__dummy_new(void)
 
 	return cpus;
 }
+
+void cpu_map__delete(struct cpu_map *map)
+{
+	free(map);
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index f7a4f42..072c0a3 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -8,6 +8,6 @@ struct cpu_map {
 
 struct cpu_map *cpu_map__new(const char *cpu_list);
 struct cpu_map *cpu_map__dummy_new(void);
-void *cpu_map__delete(struct cpu_map *map);
+void cpu_map__delete(struct cpu_map *map);
 
 #endif /* __PERF_CPUMAP_H */
