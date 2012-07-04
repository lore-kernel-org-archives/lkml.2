Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab2GDFm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:42:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab2GDFjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:42 -0400
X-AuditID: 9c930179-b7cceae000004195-44-4ff3d71b86f8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/16] tools lib traceevent: Fix %pM print format arg handling
Date: Wed,  4 Jul 2012 14:35:18 +0900
Message-Id: <1341380130-23863-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When %pM is used, the arg value must be a 6 byte character that will
be printed as a 6 byte MAC address. But the code does a break over the
main code which updates the current processing arg to point to the
next arg. If there are other print arguments after a %pM, they will be
off by one. The next arg will still be processing the %pM arg.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-q3g0n1espikynsdkpbi6ue6t@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 872dd35db051..da06c33dcf41 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3858,6 +3858,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
 					print_mac_arg(s, *(ptr+1), data, size, event, arg);
 					ptr++;
+					arg = arg->next;
 					break;
 				}
 
-- 
1.7.10.4

