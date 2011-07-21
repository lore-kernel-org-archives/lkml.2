Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1GURaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1GURaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:30:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tools: Add support to install perf python extension
Date: Thu, 21 Jul 2011 18:45:26 +0200
Message-Id: <1311266726-20655-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the distutils to use their own default 'build'
directory.

Such setup makes the install command simple, because using
--build-lib and --build-temp does not seem to comply with
the way the distutils' install commands expect it.

Also keeping the python/perf.so file, so it could be used
for testing as of until now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..9c82a56 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -178,9 +178,8 @@ strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
-	  --quiet build_ext \
-	  --build-lib='$(OUTPUT)python' \
-	  --build-temp='$(OUTPUT)python/temp'
+	  --quiet build_ext; \
+	cp $$(find build -name 'perf.so') python
 #
 # No Perl scripts right now:
 #
@@ -504,9 +503,7 @@ else
 
   PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  python-clean := $(PYTHON_WORD) util/setup.py clean \
-    --build-lib='$(OUTPUT)python' \
-    --build-temp='$(OUTPUT)python/temp'
+  python-clean := $(PYTHON_WORD) util/setup.py --quiet clean -a; $(RM) -f python/perf.so
 
   ifdef NO_LIBPYTHON
     $(call disable-python)
@@ -863,6 +860,9 @@ install: all
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 
+install-python_ext:
+	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
+
 install-doc:
 	$(MAKE) -C Documentation install
 
-- 
1.7.1

