Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2DWFAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2DWE71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:27 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-d0-4f94e1acbd09
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] parse-filter: Fix signature of create_arg_item()
Date: Mon, 23 Apr 2012 13:58:37 +0900
Message-Id: <1335157118-14658-11-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
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

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-filter.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/parse-filter.c b/parse-filter.c
index 0e6c0b1..fa6e6a2 100644
--- a/parse-filter.c
+++ b/parse-filter.c
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
1.7.10

