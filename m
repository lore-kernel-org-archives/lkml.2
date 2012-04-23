Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2DWFAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DWE70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-cb-4f94e1abf3da
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/11] parse-filter: Check result of malloc() during reading token
Date: Mon, 23 Apr 2012 13:58:36 +0900
Message-Id: <1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The malloc can fail so the return value should be checked.
For now, just use malloc_or_die().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/parse-filter.c b/parse-filter.c
index bc62f1f..0e6c0b1 100644
--- a/parse-filter.c
+++ b/parse-filter.c
@@ -96,7 +96,7 @@ static enum event_type read_token(char **tok)
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
 	    pevent_peek_char() == '~') {
 		/* append it */
-		*tok = malloc(3);
+		*tok = malloc_or_die(3);
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
-- 
1.7.10

