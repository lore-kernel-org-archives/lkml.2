Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2BFW2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:28:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48561 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2BFW2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:28:01 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf-record: no build id option fails
Date: Mon,  6 Feb 2012 15:27:52 -0700
Message-Id: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent refactoring of perf-record introduced the following:

perf record -a -B
Couldn't generating buildids. Use --no-buildid to profile anyway.
sleep: Terminated

I believe the triple negative was meant to be only a double
negative. :-) While I'm there, fixed the grammar on the
error message.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 32870ee..47a0055 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -504,9 +504,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			return err;
 	}
 
-	if (!!rec->no_buildid
+	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
-		pr_err("Couldn't generating buildids. "
+		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		return -1;
 	}
-- 
1.7.7.6

