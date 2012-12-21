Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2LUUBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:01:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2LUUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:01:39 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] tools lib traceevent: test correct variable after allocation
Date: Fri, 21 Dec 2012 15:00:58 -0500
Message-Id: <1356120062-2648-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we've tested the wrong variable for allocation failure, fix it to
test the right one.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5a824e3..7538a1f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2481,7 +2481,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	free_token(token);
 	arg = alloc_arg();
-	if (!field) {
+	if (!arg) {
 		do_warning("%s: not enough memory!", __func__);
 		*tok = NULL;
 		return EVENT_ERROR;
-- 
1.8.0

