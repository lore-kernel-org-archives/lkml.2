Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2LTTNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:13:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20956 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2LTTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:12:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] tools lib traceevent: remove redundant check from process_dynamic_array
Date: Thu, 20 Dec 2012 14:11:13 -0500
Message-Id: <1356030701-16284-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check twice that 'field' is non-NULL, no need to do that.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/traceevent/event-parse.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5a824e3..f7dc053 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2481,11 +2481,6 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	free_token(token);
 	arg = alloc_arg();
-	if (!field) {
-		do_warning("%s: not enough memory!", __func__);
-		*tok = NULL;
-		return EVENT_ERROR;
-	}
 
 	type = process_arg(event, arg, &token);
 	if (type == EVENT_ERROR)
-- 
1.8.0

