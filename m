Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981Ab2CUOP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:15:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42063 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030538Ab2CUOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:15:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH] tools/perf: Simplify event_read_id exit path
Date: Wed, 21 Mar 2012 15:15:47 +0100
Message-Id: <1332339347-21342-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're freeing the token in any case so simplify the exit path by
unifying it.

No functional change.

Signed-off-by: Borislav Petkov <bp@amd64.org>
---
 tools/perf/util/trace-event-parse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a4088ced1e64..dfd1bd8371a4 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -722,7 +722,7 @@ static char *event_read_name(void)
 static int event_read_id(void)
 {
 	char *token;
-	int id;
+	int id = -1;
 
 	if (read_expected_item(EVENT_ITEM, "ID") < 0)
 		return -1;
@@ -731,15 +731,13 @@ static int event_read_id(void)
 		return -1;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
+		goto free;
 
 	id = strtoul(token, NULL, 0);
-	free_token(token);
-	return id;
 
- fail:
+ free:
 	free_token(token);
-	return -1;
+	return id;
 }
 
 static int field_is_string(struct format_field *field)
-- 
1.7.9.3.362.g71319

