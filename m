Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab0HQOIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:08:49 -0400
Received: from msa106.auone-net.jp ([61.117.18.166]:34284 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab0HQOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:08:48 -0400
Date: Tue, 17 Aug 2010 23:08:40 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Fix build error on read only source.
References: <20100816124017.BE24D6AC03A@msa102.auone-net.jp>
 <20100816152410.GA13095@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816152410.GA13095@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20100817140841.0859362C03A@msa106.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 tools/perf/Makefile          |    8 ++++----
 tools/perf/feature-tests.mak |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 41abb90..31b528f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -935,15 +935,15 @@ $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
-	$(QUIET_GEN)$(RM) $@ $@+ && \
+	$(QUIET_GEN)$(RM) $(OUTPUT)$@ $(OUTPUT)$@+ && \
 	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' \
 	    -e 's|@SHELL_PATH@|$(SHELL_PATH_SQ)|' \
 	    -e 's|@@PERL@@|$(PERL_PATH_SQ)|g' \
 	    -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
 	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
-	    $@.sh >$@+ && \
-	chmod +x $@+ && \
-	mv $@+ $(OUTPUT)$@
+	    $@.sh > $(OUTPUT)$@+ && \
+	chmod +x $(OUTPUT)$@+ && \
+	mv $(OUTPUT)$@+ $(OUTPUT)$@
 
 configure: configure.ac
 	$(QUIET_GEN)$(RM) $@ $<+ && \
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index ddb68e6..7a7b608 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -113,7 +113,7 @@ endef
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
-	'TMP="$(TMPOUT).$$$$";			 		  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')
-- 
1.7.1

