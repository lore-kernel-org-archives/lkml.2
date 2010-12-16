Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0LPMAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:00:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41084 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0LPMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:00:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf buildid-list: Fix error return for success
Date: Thu, 16 Dec 2010 10:00:17 -0200
Message-Id: <1292500817-1348-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1292500817-1348-1-git-send-email-acme@infradead.org>
References: <1292500817-1348-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was always returning -1 (255), confusing test scripts.

Reported-by: Han Pingtian <phan@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..c49837d 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -36,7 +36,6 @@ static const struct option options[] = {
 
 static int __cmd_buildid_list(void)
 {
-	int err = -1;
 	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force, false);
@@ -49,7 +48,7 @@ static int __cmd_buildid_list(void)
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
 	perf_session__delete(session);
-	return err;
+	return 0;
 }
 
 int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
-- 
1.6.2.5

