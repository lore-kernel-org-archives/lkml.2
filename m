Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2I0FnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:43:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab2I0FnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:43:23 -0400
Date: Wed, 26 Sep 2012 22:43:01 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-aoaus46ngnt9oc2pt7ckot5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fix afterlife gotos
Git-Commit-ID: b85119200dfaf51d361008d986d591156c7473d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:43:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b85119200dfaf51d361008d986d591156c7473d4
Gitweb:     http://git.kernel.org/tip/b85119200dfaf51d361008d986d591156c7473d4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Sep 2012 15:39:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:12:59 -0300

tools lib traceevent: Fix afterlife gotos

Instead of dying, just use do_warning and let the goto that is there to
take place.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-aoaus46ngnt9oc2pt7ckot5d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2aeae55..2091991 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1270,7 +1270,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		}
 
 		if (!field->type) {
-			die("no type found");
+			do_warning("%s: no type found", __func__);
 			goto fail;
 		}
 		field->name = last_token;
@@ -1317,7 +1317,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				free_token(token);
 				type = read_token(&token);
 				if (type == EVENT_NONE) {
-					die("failed to find token");
+					do_warning("failed to find token");
 					goto fail;
 				}
 			}
@@ -1669,7 +1669,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	if (arg->type == PRINT_OP && !arg->op.left) {
 		/* handle single op */
 		if (token[1]) {
-			die("bad op token %s", token);
+			do_warning("bad op token %s", token);
 			goto out_free;
 		}
 		switch (token[0]) {
