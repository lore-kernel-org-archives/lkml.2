Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2KNHpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:45:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2KNHpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:45:34 -0500
Date: Tue, 13 Nov 2012 23:45:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-soe4gqcz8fd4ecik6exvyqox@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add __maybe_unused to unused parameters
Git-Commit-ID: ca383a4df77a07e607123d7763facdc00ce32796
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:45:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca383a4df77a07e607123d7763facdc00ce32796
Gitweb:     http://git.kernel.org/tip/ca383a4df77a07e607123d7763facdc00ce32796
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 15:18:57 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 17:34:39 -0300

tools lib traceevent: Add __maybe_unused to unused parameters

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
 1 files changed, 4 insertions(+), 3 deletions(-)

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
