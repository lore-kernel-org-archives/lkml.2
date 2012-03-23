Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2CWI3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:29:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2CWI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:29:35 -0400
Date: Fri, 23 Mar 2012 01:28:57 -0700
From: tip-bot for Borislav Petkov <bp@amd64.org>
Message-ID: <tip-842f07f6127afa48cca6b2ce9021b985e8eb9068@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@amd64.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, bp@amd64.org
In-Reply-To: <1332339347-21342-1-git-send-email-bp@amd64.org>
References: <1332339347-21342-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Simplify event_read_id exit path
Git-Commit-ID: 842f07f6127afa48cca6b2ce9021b985e8eb9068
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 01:29:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  842f07f6127afa48cca6b2ce9021b985e8eb9068
Gitweb:     http://git.kernel.org/tip/842f07f6127afa48cca6b2ce9021b985e8eb9068
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Wed, 21 Mar 2012 15:15:47 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Mar 2012 15:10:42 -0300

perf tools: Simplify event_read_id exit path

We're freeing the token in any case so simplify the exit path by
unifying it.

No functional change.

Signed-off-by: Borislav Petkov <bp@amd64.org>
Link: http://lkml.kernel.org/r/1332339347-21342-1-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

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
