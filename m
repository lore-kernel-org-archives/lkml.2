Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab2EXRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:21:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2EXRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:21:18 -0400
Date: Thu, 24 May 2012 10:20:46 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-eaec12d7f526694f24d581a4ad23de6ce0315cd2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@alien8.de, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1337740619-27925-20-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-20-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix signature of create_arg_item()
Git-Commit-ID: eaec12d7f526694f24d581a4ad23de6ce0315cd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 10:20:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eaec12d7f526694f24d581a4ad23de6ce0315cd2
Gitweb:     http://git.kernel.org/tip/eaec12d7f526694f24d581a4ad23de6ce0315cd2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 23 May 2012 11:36:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 May 2012 11:36:05 -0300

tools lib traceevent: Fix signature of create_arg_item()

The @type should be a type of enum event_type not enum filter_arg_type.

This fixes following warning:

 $ make
  COMPILE FPIC           parse-events.o
  COMPILE FPIC           parse-filter.o
/home/namhyung/project/trace-cmd/parse-filter.c: In function ‘create_arg_item’:
/home/namhyung/project/trace-cmd/parse-filter.c:343:9: warning: comparison between ‘enum filter_arg_type’ and ‘enum event_type’ [-Wenum-compare]
/home/namhyung/project/trace-cmd/parse-filter.c:339:2: warning: case value ‘8’ not in enumerated type ‘enum filter_arg_type’ [-Wswitch]
  BUILD STATIC LIB       libparsevent.a
  BUILD STATIC LIB       libtracecmd.a
  BUILD                  trace-cmd
/usr/bin/make -C /home/namhyung/project/trace-cmd/Documentation all
make[1]: Nothing to be done for `all'.
Note: to build the gui, type "make gui"

Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-20-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2d40c5e..e08d21f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -325,9 +325,8 @@ static void free_events(struct event_list *events)
 }
 
 static struct filter_arg *
-create_arg_item(struct event_format *event,
-		const char *token, enum filter_arg_type type,
-		char **error_str)
+create_arg_item(struct event_format *event, const char *token,
+		enum event_type type, char **error_str)
 {
 	struct format_field *field;
 	struct filter_arg *arg;
