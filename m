Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab1LWVyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:54:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57953 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1LWVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/15] perf tools: Fix out-of-bound access to struct perf_session
Date: Fri, 23 Dec 2011 19:53:13 -0200
Message-Id: <1324677198-5191-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

If filename is NULL there is an out-of-bound access to struct
perf_session if it would be used with perf_session__open(). Shouldn't
actually happen in current implementation as filename is always !NULL.
Fixing this by always null-terminating filename.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-3-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 tools/perf/util/session.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d9318d8..ea17dfb 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -107,7 +107,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool)
 {
-	size_t len = filename ? strlen(filename) + 1 : 0;
+	size_t len = filename ? strlen(filename) : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index fb69612..37bc383 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -50,7 +50,7 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	char			filename[0];
+	char			filename[1];
 };
 
 struct perf_tool;
-- 
1.7.8.rc0.35.gee6df

