Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1DTQYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:24:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab1DTQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] perf tools: Makefile: Clean up `python/perf.so' rule
Date: Wed, 20 Apr 2011 13:23:52 -0300
Message-Id: <1303316636-11923-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

There is no need for a subshell or an explicit `export';
as per the POSIX Shell Command Language specification:

  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_01
  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_10_02

It is only necessary to include the environment variable
assignment just before the command to be run.

Also, it is better to use single-quotes, because GNU make
might expand `$(BASIC_CFLAGS)' into something that the shell
could interpret within double-quotes.

Acked-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Link: http://lkml.kernel.org/n/tip-58n38o02ocuzrm9qh096hsf5@git.kernel.org
Signed-off-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 207dee5..aaf4dd3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -165,12 +165,10 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)( \
-		export CFLAGS="$(BASIC_CFLAGS)"; \
-		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-			--build-temp='$(OUTPUT)python/temp' \
-	)
-
+	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' python util/setup.py \
+	  --quiet build_ext \
+	  --build-lib='$(OUTPUT)python' \
+	  --build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
-- 
1.6.2.5

