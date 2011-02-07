Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1BGPAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:00:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1BGPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] perf tools: Makefile: Use $(QUIET_GEN) for perf.so
Date: Mon,  7 Feb 2011 13:00:04 -0200
Message-Id: <1297090812-10782-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

So that we get this:

    CC /home/acme/git/build/perf/bench/mem-memcpy-x86-64-asm.o
    GEN perf-archive
*   GEN /home/acme/git/build/perf/python/perf.so
    CC /home/acme/git/build/perf/builtin-annotate.o

Instead of silently building the python binding.

LKML-Reference: <1296890359-22659-1-git-send-email-mfwitten@gmail.com>
Signed-off-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index be3eb1d..94f73ab 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -326,7 +326,7 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	@python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
 						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
-- 
1.6.2.5

