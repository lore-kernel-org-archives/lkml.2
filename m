Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2KIVq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:46:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:38573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab2KIVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 17/21] tools lib traceevent: Add __maybe_unused to unused parameters
Date: Fri,  9 Nov 2012 18:43:06 -0300
Message-Id: <1352497390-17716-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing the build on 32-bit Fedora 14:

  tools/lib/traceevent/event-parse.c: In function ‘print_event_fields’:
  tools/lib/traceevent/event-parse.c:3934:69: error: unused parameter ‘size’
  tools/lib/traceevent/event-parse.c: In function ‘pevent_strerror’:
  tools/lib/traceevent/event-parse.c:5074:36: error: unused parameter ‘pevent’

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-soe4gqcz8fd4ecik6exvyqox@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f2989c5..0dcc18c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3931,7 +3931,8 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-static void print_event_fields(struct trace_seq *s, void *data, int size,
+static void print_event_fields(struct trace_seq *s, void *data,
+			       int size __maybe_unused,
 			       struct event_format *event)
 {
 	struct format_field *field;
@@ -5070,8 +5071,8 @@ static const char * const pevent_error_str[] = {
 };
 #undef _PE
 
-int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
-		    char *buf, size_t buflen)
+int pevent_strerror(struct pevent *pevent __maybe_unused,
+		    enum pevent_errno errnum, char *buf, size_t buflen)
 {
 	int idx;
 	const char *msg;
-- 
1.7.9.2.358.g22243

