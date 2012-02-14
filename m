Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab2BNByQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2BNBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/16] perf record: No build id option fails
Date: Mon, 13 Feb 2012 23:52:41 -0200
Message-Id: <1329184375-27911-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A recent refactoring of perf-record introduced the following:

perf record -a -B
Couldn't generating buildids. Use --no-buildid to profile anyway.
sleep: Terminated

I believe the triple negative was meant to be only a double negative.
:-) While I'm there, fixed the grammar on the error message.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1328567272-13190-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f8d9a54..d6d1c6c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -494,9 +494,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			return err;
 	}
 
-	if (!!rec->no_buildid
+	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
-		pr_err("Couldn't generating buildids. "
+		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		return -1;
 	}
-- 
1.7.9.123.g65da0

