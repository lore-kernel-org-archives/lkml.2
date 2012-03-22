Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2CVSdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:33:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46291 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2CVSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:33:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf tools: Simplify event_read_id exit path
Date: Thu, 22 Mar 2012 15:33:00 -0300
Message-Id: <1332441183-9514-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1332441183-9514-1-git-send-email-acme@infradead.org>
References: <1332441183-9514-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>

We're freeing the token in any case so simplify the exit path by
unifying it.

No functional change.

Signed-off-by: Borislav Petkov <bp@amd64.org>
Link: http://lkml.kernel.org/r/1332339347-21342-1-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a4088ce..dfd1bd8 100644
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
1.7.9.2.358.g22243

