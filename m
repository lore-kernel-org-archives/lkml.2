Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2BNBxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:53:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45723 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2BNBxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/16] perf tools: cleanup initialization of attr->size
Date: Mon, 13 Feb 2012 23:52:55 -0200
Message-Id: <1329184375-27911-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The perf_event_attr size needs to be initialized in all cases because it
captures the ABI version.

This patch moves the initialization of the field from the
perf_event_open() syscall stub to its proper location in the
event_attr_init().

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120209151238.GA10272@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h      |    1 -
 tools/perf/util/util.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index deb17db..03a0456 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -167,7 +167,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	attr->size = sizeof(*attr);
 	return syscall(__NR_perf_event_open, attr, pid, cpu,
 		       group_fd, flags);
 }
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index fb25d13..8109a90 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,8 @@ void event_attr_init(struct perf_event_attr *attr)
 		attr->exclude_host  = 1;
 	if (!perf_guest)
 		attr->exclude_guest = 1;
+	/* to capture ABI version */
+	attr->size = sizeof(*attr);
 }
 
 int mkdir_p(char *path, mode_t mode)
-- 
1.7.9.123.g65da0

