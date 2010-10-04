Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0JDSzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:55:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:37850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab0JDSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:55:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Bernd Petrovitsch <bernd@sysprog.at>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Fix build breakage
Date: Mon,  4 Oct 2010 15:54:41 -0300
Message-Id: <1286218483-7219-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1286218483-7219-1-git-send-email-acme@infradead.org>
References: <1286218483-7219-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

The patch ecafda6 introduced a problem where all object files would be
always rebuilt, fix it by using:

http://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Bernd Petrovitsch <bernd@sysprog.at>
Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4f1fa77..1950e19 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1017,7 +1017,7 @@ builtin-revert.o wt-status.o: wt-status.h
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
 DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
 # In the second step, we make a rule to actually create these directories
 $(sort $(dir $(DIRECTORY_DEPS))):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
-- 
1.6.2.5

