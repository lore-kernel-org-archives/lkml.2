Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab0FQUkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:40:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0FQUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/7] perf record: Avoid synthesizing mmap() for all processes in per-thread mode
Date: Thu, 17 Jun 2010 17:39:58 -0300
Message-Id: <1276807204-22512-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

A bug was introduced by commit c45c6ea2e5c57960dc67e00294c2b78e9540c007.

Perf record was scanning /proc/PID to create synthetic PERF_RECOR_MMAP
entries even though it was running in per-thread mode. There was a bogus
check to select what mmaps to synthesize. We only need all processes in
system-wide mode.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <4c192107.4f1ee30a.4316.fffff98e@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 39c7247..5efc3fc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -714,7 +714,7 @@ static int __cmd_record(int argc, const char **argv)
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
-	if (!system_wide && cpu_list)
+	if (!system_wide)
 		event__synthesize_thread(target_tid, process_synthesized_event,
 					 session);
 	else
-- 
1.6.2.5

