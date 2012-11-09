Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2KIVqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:46:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48182 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2KIVn2 (ORCPT
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
Subject: [PATCH 20/21] tools lib traceevent: Handle INVALID_ARG_TYPE errno in pevent_strerror
Date: Fri,  9 Nov 2012 18:43:09 -0300
Message-Id: <1352497390-17716-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 1 file changed, 1 insertion(+)

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
 
-- 
1.7.9.2.358.g22243

