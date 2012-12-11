Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2LKWyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:23 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53837
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/37] perf tools: Don't check configuration on make tags
Date: Tue, 11 Dec 2012 19:48:04 -0300
Message-Id: <1355266103-17238-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Doing the same thing done in:

  b059dee: perf tools: Don't check configuration on make clean

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n2ni4riphpqxw7d6ziv1ndyc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |    2 ++
 tools/perf/Makefile               |    4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index f6e5901..eb30044 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -223,11 +223,13 @@ install-pdf: pdf
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
 -include $(OUTPUT)PERF-VERSION-FILE
 endif
+endif
 
 #
 # Determine "include::" file references in asciidoc files.
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 08da9fc..2a07b95 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -154,6 +154,7 @@ INSTALL = install
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 -include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
@@ -207,6 +208,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
 # Guard against environment variables
@@ -525,6 +527,7 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 # Platform specific tweaks
 #
 ifneq ($(MAKECMDGOALS),clean)
+ifneq ($(MAKECMDGOALS),tags)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -841,6 +844,7 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
+endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
-- 
1.7.9.2.358.g22243

