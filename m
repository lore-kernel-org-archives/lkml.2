Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2DMSQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2DMSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:16:04 -0400
Date: Fri, 13 Apr 2012 11:14:43 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-98d89bfd0d4b2f218ec709e90ddcab6d82d7671e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        borislav.petkov@amd.com
In-Reply-To: <1334162178-17152-2-git-send-email-bp@amd64.org>
References: <1334162178-17152-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools: Add Makefile.include
Git-Commit-ID: 98d89bfd0d4b2f218ec709e90ddcab6d82d7671e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98d89bfd0d4b2f218ec709e90ddcab6d82d7671e
Gitweb:     http://git.kernel.org/tip/98d89bfd0d4b2f218ec709e90ddcab6d82d7671e
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 11 Apr 2012 18:36:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 14:57:36 -0300

tools: Add Makefile.include

Put generic enough build settings which could be reused by other tools
into a common Makefile.include file.

This commit reintroduces QUIET_SUBDIR{0,1} (see a3d1ee10d1bf) which are
going to be used in the following patches.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-2-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |   47 +--------------------------------
 tools/scripts/Makefile.include |   57 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..4ca77cc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,18 +1,10 @@
-ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-endif
+include ../scripts/Makefile.include
 
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
 # Define O to save output files in a separate directory.
@@ -84,31 +76,6 @@ ifneq ($(WERROR),0)
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
@@ -679,18 +646,6 @@ else
 	endif
 endif
 
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
-	QUIET_FLEX     = @echo '   ' FLEX $@;
-	QUIET_BISON    = @echo '   ' BISON $@;
-endif
-endif
-
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
new file mode 100644
index 0000000..52348d3
--- /dev/null
+++ b/tools/scripts/Makefile.include
@@ -0,0 +1,57 @@
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
+	QUIET_FLEX     = @echo '   ' FLEX $@;
+	QUIET_BISON    = @echo '   ' BISON $@;
+endif
+endif
