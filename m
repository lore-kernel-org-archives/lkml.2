Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2DWFAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DWE7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:25 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-ba-4f94e1aa3fe4
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] parse-events: Use proper function parameter type
Date: Mon, 23 Apr 2012 13:58:32 +0900
Message-Id: <1335157118-14658-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The param needs to be updated when setting args up so that
the loop in process_defined_func() can see the correct
param->type for the farg.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/parse-events.c b/parse-events.c
index 3e5ac44..b7c81d8 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3396,6 +3396,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			break;
 		}
 		farg = farg->next;
+		param = param->next;
 	}
 
 	ret = (*func_handle->func)(s, args);
-- 
1.7.10

