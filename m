Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab2GFLTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab2GFLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:19:35 -0400
Date: Fri, 6 Jul 2012 04:19:09 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e54b34aed1c4082ed03f4d1f7a19276059b1e30a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@alien8.de,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Check result of malloc()
  during reading token
Git-Commit-ID: e54b34aed1c4082ed03f4d1f7a19276059b1e30a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:19:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e54b34aed1c4082ed03f4d1f7a19276059b1e30a
Gitweb:     http://git.kernel.org/tip/e54b34aed1c4082ed03f4d1f7a19276059b1e30a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 23 Apr 2012 13:58:36 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Check result of malloc() during reading token

The malloc can fail so the return value should be checked.  For now,
just use malloc_or_die().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-10-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 80d872a..d54c2b4 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -96,7 +96,7 @@ static enum event_type read_token(char **tok)
 	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
 	    pevent_peek_char() == '~') {
 		/* append it */
-		*tok = malloc(3);
+		*tok = malloc_or_die(3);
 		sprintf(*tok, "%c%c", *token, '~');
 		free_token(token);
 		/* Now remove the '~' from the buffer */
