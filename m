Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab2GDFka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:40:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab2GDFjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:49 -0400
X-AuditID: 9c930179-b7cceae000004195-8d-4ff3d7200ae3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 15/16] tools lib traceevent: Add missing break in make_bprint_args
Date: Wed,  4 Jul 2012 14:35:29 +0900
Message-Id: <1341380130-23863-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

In the current code we assign vsize=8 and then fall through to the
default and assign vsize=1. -> probably the break is missing here,
otherwise we can remove the case.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-3fxjy46h2tr9pl0spv7tems6@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 863016040dd6..f880db457842 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3594,6 +3594,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 					break;
 				case 2:
 					vsize = 8;
+					break;
 				default:
 					vsize = ls; /* ? */
 					break;
-- 
1.7.10.4

