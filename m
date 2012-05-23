Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab2EWCjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:08 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab2EWCjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:04 -0400
X-AuditID: 9c93016f-b7c3cae000001954-77-4fbc4dc5cf43
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/22] lib/traceevent: Fix %pM print format arg handling
Date: Wed, 23 May 2012 11:36:41 +0900
Message-Id: <1337740619-27925-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When %pM is used, the arg value must be a 6 byte character that
will be printed as a 6 byte MAC address. But the code does a break
over the main code which updates the current processing arg to point
to the next arg. If there are other print arguments after a %pM,
they will be off by one. The next arg will still be processing the
%pM arg.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4dc0313b4a50..9216aef78394 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3761,6 +3761,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
 					print_mac_arg(s, *(ptr+1), data, size, event, arg);
 					ptr++;
+					arg = arg->next;
 					break;
 				}
 
-- 
1.7.10.1

