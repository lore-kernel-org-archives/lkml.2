Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031096Ab2CVRCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:02:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48412 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031041Ab2CVRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:01:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] tools: Add Makefile.lib
Date: Thu, 22 Mar 2012 18:01:52 +0100
Message-Id: <1332435713-32143-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1332435713-32143-1-git-send-email-bp@amd64.org>
References: <1332435713-32143-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Put generic enough build settings which could be reused by other tools
into a common Makefile.lib file.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/perf/Makefile        |   45 +-----------------------------------
 tools/scripts/Makefile.lib |   55 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 44 deletions(-)
 create mode 100644 tools/scripts/Makefile.lib

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a4b9bccf8b2..3c0bfa39eb8b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,18 +1,10 @@
-ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-endif
+include ../scripts/Makefile.lib
 
 # The default target of this Makefile is...
 all:
 
 include config/utilities.mak
 
-ifneq ($(OUTPUT),)
-# check that the output directory actually exists
-OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
-$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
-endif
-
 # Define V to have a more verbose compile.
 #
 # Define PYTHON to point to the python binary if the default
@@ -70,31 +62,6 @@ ifneq ($(WERROR),0)
 	CFLAGS_WERROR := -Werror
 endif
 
-#
-# Include saner warnings here, which can catch bugs:
-#
-
-EXTRA_WARNINGS := -Wformat
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
-
 ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
@@ -619,16 +586,6 @@ else
 	endif
 endif
 
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
-endif
-endif
-
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/scripts/Makefile.lib b/tools/scripts/Makefile.lib
new file mode 100644
index 000000000000..a2586d13bcf8
--- /dev/null
+++ b/tools/scripts/Makefile.lib
@@ -0,0 +1,55 @@
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
+#
+# Include saner warnings here, which can catch bugs:
+#
+EXTRA_WARNINGS := -Wformat
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+
+ifneq ($(findstring $(MAKEFLAGS), w),w)
+PRINT_DIR = --no-print-directory
+else
+NO_SUBDIR = :
+endif
+
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_CC       = @echo '   ' CC $@;
+	QUIET_AR       = @echo '   ' AR $@;
+	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_MKDIR    = @echo '   ' MKDIR $@;
+	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_SUBDIR0  = +@subdir=
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			 $(MAKE) $(PRINT_DIR) -C $$subdir
+endif
+endif
-- 
1.7.9.3.362.g71319

