Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AYR1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:27:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:46981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1AYRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 12/29] perf tools: Add missing cpu_map__delete()
Date: Tue, 25 Jan 2011 15:21:35 -0200
Message-Id: <1295976112-2796-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

