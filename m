Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1BRSsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:48:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1BRSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:47:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf tools: Makefile: Remove vestigial git-specific cruft
Date: Fri, 18 Feb 2011 16:47:49 -0200
Message-Id: <1298054872-16434-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298054872-16434-1-git-send-email-acme@infradead.org>
References: <1298054872-16434-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

This commit squashes several commits that remove:

 NO_SYMLINK_HEAD
 NO_SVN_TESTS
 NO_FAST_WORKING_DIRECTORY
 USE_STDEV
 SHA1/SSL cruft
 makefile rules

Signed-off-by: Michael Witten <mfwitten@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   62 +--------------------------------------------------
 1 files changed, 1 insertions(+), 61 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7c75f1d..544367c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -21,9 +21,6 @@ endif
 # Define FREAD_READS_DIRECTORIES if your are on a system which succeeds
 # when attempting to read from an fopen'ed directory.
 #
-# Define NO_OPENSSL environment variable if you do not have OpenSSL.
-# This also implies MOZILLA_SHA1.
-#
 # Define CURLDIR=/foo/bar if your curl header and library files are in
 # /foo/bar/include and /foo/bar/lib directories.
 #
@@ -56,13 +53,6 @@ endif
 #
 # Define NO_SYS_SELECT_H if you don't have sys/select.h.
 #
-# Define NO_SYMLINK_HEAD if you never want .perf/HEAD to be a symbolic link.
-# Enable it on Windows.  By default, symrefs are still used.
-#
-# Define NO_SVN_TESTS if you want to skip time-consuming SVN interoperability
-# tests.  These tests take up a significant amount of the total test time
-# but are not needed unless you plan to talk to SVN repos.
-#
 # Define NO_FINK if you are building on Darwin/Mac OS X, have Fink
 # installed in /sw, but don't want PERF to link against any libraries
 # installed there.  If defined you may specify your own (or Fink's)
@@ -75,19 +65,6 @@ endif
 # specify your own (or DarwinPort's) include directories and
 # library directories by defining CFLAGS and LDFLAGS appropriately.
 #
-# Define PPC_SHA1 environment variable when running make to make use of
-# a bundled SHA1 routine optimized for PowerPC.
-#
-# Define ARM_SHA1 environment variable when running make to make use of
-# a bundled SHA1 routine optimized for ARM.
-#
-# Define MOZILLA_SHA1 environment variable when running make to make use of
-# a bundled SHA1 routine coming from Mozilla. It is GPL'd and should be fast
-# on non-x86 architectures (e.g. PowerPC), while the OpenSSL version (default
-# choice) has very fast version optimized for i586.
-#
-# Define NEEDS_SSL_WITH_CRYPTO if you need -lcrypto with -lssl (Darwin).
-#
 # Define NEEDS_LIBICONV if linking with libc is not enough (Darwin).
 #
 # Define NEEDS_SOCKET if linking with libc is not enough (SunOS,
@@ -100,9 +77,6 @@ endif
 # Define NO_PREAD if you have a problem with pread() system call (e.g.
 # cygwin.dll before v1.5.22).
 #
-# Define NO_FAST_WORKING_DIRECTORY if accessing objects in pack files is
-# generally faster on your platform than accessing the working directory.
-#
 # Define NO_TRUSTABLE_FILEMODE if your filesystem may claim to support
 # the executable mode bit, but doesn't really do so.
 #
@@ -134,9 +108,6 @@ endif
 # Define NO_NSEC if your "struct stat" does not have "st_ctim.tv_nsec"
 # available.  This automatically turns USE_NSEC off.
 #
-# Define USE_STDEV below if you want perf to care about the underlying device
-# change being considered an inode change from the update-index perspective.
-#
 # Define NO_ST_BLOCKS_IN_STRUCT_STAT if your platform does not have st_blocks
 # field that counts the on-disk footprint in 512-byte blocks.
 #
@@ -771,9 +742,6 @@ ifdef FREAD_READS_DIRECTORIES
 	COMPAT_CFLAGS += -DFREAD_READS_DIRECTORIES
 	COMPAT_OBJS += $(OUTPUT)compat/fopen.o
 endif
-ifdef NO_SYMLINK_HEAD
-	BASIC_CFLAGS += -DNO_SYMLINK_HEAD
-endif
 ifdef NO_STRCASESTR
 	COMPAT_CFLAGS += -DNO_STRCASESTR
 	COMPAT_OBJS += $(OUTPUT)compat/strcasestr.o
@@ -813,9 +781,6 @@ ifdef NO_PREAD
 	COMPAT_CFLAGS += -DNO_PREAD
 	COMPAT_OBJS += $(OUTPUT)compat/pread.o
 endif
-ifdef NO_FAST_WORKING_DIRECTORY
-	BASIC_CFLAGS += -DNO_FAST_WORKING_DIRECTORY
-endif
 ifdef NO_TRUSTABLE_FILEMODE
 	BASIC_CFLAGS += -DNO_TRUSTABLE_FILEMODE
 endif
@@ -851,23 +816,6 @@ ifdef NO_DEFLATE_BOUND
 	BASIC_CFLAGS += -DNO_DEFLATE_BOUND
 endif
 
-ifdef PPC_SHA1
-	SHA1_HEADER = "ppc/sha1.h"
-	LIB_OBJS += $(OUTPUT)ppc/sha1.o ppc/sha1ppc.o
-else
-ifdef ARM_SHA1
-	SHA1_HEADER = "arm/sha1.h"
-	LIB_OBJS += $(OUTPUT)arm/sha1.o $(OUTPUT)arm/sha1_arm.o
-else
-ifdef MOZILLA_SHA1
-	SHA1_HEADER = "mozilla-sha1/sha1.h"
-	LIB_OBJS += $(OUTPUT)mozilla-sha1/sha1.o
-else
-	SHA1_HEADER = <openssl/sha.h>
-	EXTLIBS += $(LIB_4_CRYPTO)
-endif
-endif
-endif
 ifdef NO_PERL_MAKEMAKER
 	export NO_PERL_MAKEMAKER
 endif
@@ -930,7 +878,6 @@ endif
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
 
-SHA1_HEADER_SQ = $(subst ','\'',$(SHA1_HEADER))
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
 
 DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
@@ -948,8 +895,7 @@ PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
 
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
 
-BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
-	$(COMPAT_CFLAGS)
+BASIC_CFLAGS += $(COMPAT_CFLAGS)
 LIB_OBJS += $(COMPAT_OBJS)
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
@@ -1048,9 +994,6 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
-$(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_PERF_TEMPLATE_DIR='"$(template_dir_SQ)"' $<
-
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
@@ -1089,7 +1032,6 @@ $(OUTPUT)perf-%$X: %.o $(PERFLIBS)
 
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
-builtin-revert.o wt-status.o: wt-status.h
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
@@ -1192,8 +1134,6 @@ all:: $(TEST_PROGRAMS)
 # However, the environment gets quite big, and some programs have problems
 # with that.
 
-export NO_SVN_TESTS
-
 check: $(OUTPUT)common-cmds.h
 	if sparse; \
 	then \
-- 
1.6.2.5

