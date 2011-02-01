Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1BARa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:30:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:47606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab1BARa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:30:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf tools: Fix up 'make clean' target
Date: Tue,  1 Feb 2011 15:29:55 -0200
Message-Id: <1296581395-30663-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296581395-30663-1-git-send-email-acme@infradead.org>
References: <1296581395-30663-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It wasn't using $(OUTPUT) to rm *.o and there were some funny looking
automake files that never get created but were being deleted anyway.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d1984ee..85f6549 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1289,12 +1289,10 @@ distclean: clean
 #	$(RM) configure
 
 clean:
-	$(RM) *.o */*.o */*/*.o */*/*/*.o $(LIB_FILE)
+	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
 	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf$X
 	$(RM) $(TEST_PROGRAMS)
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
-	$(RM) -r autom4te.cache
-	$(RM) config.log config.mak.autogen config.mak.append config.status config.cache
 	$(RM) -r $(PERF_TARNAME) .doc-tmp-dir
 	$(RM) $(PERF_TARNAME).tar.gz perf-core_$(PERF_VERSION)-*.tar.gz
 	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
-- 
1.6.2.5

