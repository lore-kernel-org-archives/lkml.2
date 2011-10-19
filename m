Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1JSSXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:23:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1JSSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf tools: Add prelink suggestion to dso update message
Date: Wed, 19 Oct 2011 16:23:35 -0200
Message-Id: <1319048618-9790-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Following a prelink run mapped files for long running processes can show
as deleted. The current message suggests restarting long running
processes. Add to that a suggestion that prelink might be the cause.

Old message:
/lib64/libc-2.14.so was updated, restart the long running
 apps that use it!

New message:
/lib64/libc-2.14.so was updated (is prelink enabled?).
  Restart the long running apps that use it!

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1318985085-20776-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9cf0d43..78284b1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -139,8 +139,8 @@ int map__load(struct map *self, symbol_filter_t filter)
 
 		if (len > sizeof(DSO__DELETED) &&
 		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-			pr_warning("%.*s was updated, restart the long "
-				   "running apps that use it!\n",
+			pr_warning("%.*s was updated (is prelink enabled?). "
+				"Restart the long running apps that use it!\n",
 				   (int)real_len, name);
 		} else {
 			pr_warning("no symbols found in %s, maybe install "
-- 
1.6.2.5

