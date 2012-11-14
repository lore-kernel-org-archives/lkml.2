Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab2KNHrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:47:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2KNHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:47:31 -0500
Date: Tue, 13 Nov 2012 23:47:11 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6vnd6ud6fbpn48zax4a5ru01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: No need to check for <
  0 on an unsigned enum
Git-Commit-ID: e46466b8bd5918626250dc0d6cb6c2147a611087
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:47:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e46466b8bd5918626250dc0d6cb6c2147a611087
Gitweb:     http://git.kernel.org/tip/e46466b8bd5918626250dc0d6cb6c2147a611087
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 15:42:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 17:35:15 -0300

tools lib traceevent: No need to check for < 0 on an unsigned enum

gcc on f14 32-bit complains:

  tools/lib/traceevent/event-parse.c: In function ‘pevent_register_print_function’:
  tools/lib/traceevent/event-parse.c:5366:3: error: comparison of unsigned expression < 0 is always false

This is because:

          enum pevent_func_arg_type type;

this enum doesn't have any negative value, so gcc makes it an 'unsigned
int'. Fix it by removing the < 0 test.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-6vnd6ud6fbpn48zax4a5ru01@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6b647c1..38d65958 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5363,7 +5363,7 @@ int pevent_register_print_function(struct pevent *pevent,
 		if (type == PEVENT_FUNC_ARG_VOID)
 			break;
 
-		if (type < 0 || type >= PEVENT_FUNC_ARG_MAX_TYPES) {
+		if (type >= PEVENT_FUNC_ARG_MAX_TYPES) {
 			do_warning("Invalid argument type %d", type);
 			ret = PEVENT_ERRNO__INVALID_ARG_TYPE;
 			goto out_free;
