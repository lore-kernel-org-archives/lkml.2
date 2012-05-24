Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2EXQkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:40:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2EXQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] tools lib traceevent: Fix signature of create_arg_item()
Date: Thu, 24 May 2012 13:40:13 -0300
Message-Id: <1337877613-15133-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337877613-15133-1-git-send-email-acme@infradead.org>
References: <1337877613-15133-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 1 file changed, 2 insertions(+), 3 deletions(-)

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
-- 
1.7.9.2.358.g22243

