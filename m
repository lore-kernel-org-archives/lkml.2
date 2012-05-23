Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984Ab2EWCjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab2EWCjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:12 -0400
X-AuditID: 9c93016f-b7c3cae000001954-23-4fbc4dce2cf6
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/22] lib/traceevent: Fix signature of create_arg_item()
Date: Wed, 23 May 2012 11:36:56 +0900
Message-Id: <1337740619-27925-20-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @type should be a type of enum event_type not enum
filter_arg_type. This fixes following warning:

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

Link: http://lkml.kernel.org/r/1335157118-14658-11-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/parse-filter.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 901f2de5bd67..a224938e1728 100644
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
-- 
1.7.10.1

