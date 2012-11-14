Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab2KNHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:48:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44455 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2KNHsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:48:38 -0500
Date: Tue, 13 Nov 2012 23:48:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-c68zkvxw4289uqbosfkz963g@git.kernel.org>
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
  Handle INVALID_ARG_TYPE errno in pevent_strerror
Git-Commit-ID: 7a905611644c015e68a955f263fd0a4b7b20879d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:48:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a905611644c015e68a955f263fd0a4b7b20879d
Gitweb:     http://git.kernel.org/tip/7a905611644c015e68a955f263fd0a4b7b20879d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 15:50:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 17:35:31 -0300

tools lib traceevent: Handle INVALID_ARG_TYPE errno in pevent_strerror

gcc on f14 32-bit rightly complains:

   tools/lib/traceevent/event-parse.c:5097:2: error: enumeration value ‘PEVENT_ERRNO__INVALID_ARG_TYPE’ not handled in switch

The entry for it is in the error strings array pevent_error_str[]:

        _PE(INVALID_ARG_TYPE,   "invalid argument type")

It was just not being handled on the pevent_strerror switch, fix it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-c68zkvxw4289uqbosfkz963g@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 38d65958..669953a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5101,6 +5101,7 @@ int pevent_strerror(struct pevent *pevent __maybe_unused,
 	case PEVENT_ERRNO__READ_FORMAT_FAILED:
 	case PEVENT_ERRNO__READ_PRINT_FAILED:
 	case PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED:
+	case PEVENT_ERRNO__INVALID_ARG_TYPE:
 		snprintf(buf, buflen, "%s", msg);
 		break;
 
