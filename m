Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab2EWCj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49362 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572Ab2EWCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:13 -0400
X-AuditID: 9c93016f-b7c3cae000001954-39-4fbc4dcf9016
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 21/22] lib/traceevent: Add missing break in make_bprint_args
Date: Wed, 23 May 2012 11:36:58 +0900
Message-Id: <1337740619-27925-22-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

In the current code we asign vsize=8 and then fall through to the
default and asign vsize=1. -> probably the break is missing here,
otherwise we can remove the case.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f62f76658d51..f02890530425 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3523,6 +3523,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 					break;
 				case 2:
 					vsize = 8;
+					break;
 				default:
 					vsize = ls; /* ? */
 					break;
-- 
1.7.10.1

