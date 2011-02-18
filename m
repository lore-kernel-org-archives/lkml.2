Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1BRSsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:48:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1BRSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:47:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf tools: Makefile: Remove platform-specific cruft
Date: Fri, 18 Feb 2011 16:47:50 -0200
Message-Id: <1298054872-16434-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298054872-16434-1-git-send-email-acme@infradead.org>
References: <1298054872-16434-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Witten <mfwitten@gmail.com>

While it makes sense that this tool could be used on
other platforms at least to parse data, there doesn't
appear to be any real support for such usage.

This commit squashes several commits that remove:

 SNPRINTF_RETURNS_BOGUS
 FREAD_READS_DIRECTORIES
 NO_D_{INO,TYPE}_IN_DIRENT
 NO_STRCASESTR
 NO_MEMMEM
 NO_STRTOUMAX and NO_STRTOULL
 NO_SETENV
 NO_UNSETENV
 NO_MKDTEMP
 NEEDS_LIBICONV
 NEEDS_SOCKET
 NO_MMAP
 NO_PTHREADS
 NO_PREAD
 NO_TRUSTABLE_FILEMODE
 NO_IPV6 and NO_SOCKADDR_STORAGE
 NO_ICONV and OLD_ICONV
 NO_NSEC, USE_NSEC, and USE_ST_TIMESPEC
 NO_ST_BLOCKS_IN_STRUCT_STAT
 NO_FINK and NO_DARWIN_PORTS
 NO_SYS_SELECT_H
 NO_HSTRERROR
 DIR_HAS_BSD_GROUP_SEMANTICS and FORCE_DIR_SET_GID
 NEEDS_NSL, NO_UINTMAX_T, NO_INET_{N,P}TON
 COMPAT_{CFLAGS,OBJS}
 Executable extension `X'

Signed-off-by: Michael Witten <mfwitten@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile    |  232 ++----------------------------------------------
 tools/perf/util/util.h |   26 ------
 2 files changed, 8 insertions(+), 250 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 544367c..53c1e93 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -14,103 +14,23 @@ endif
 # Define V=1 to have a more verbose compile.
 # Define V=2 to have an even more verbose compile.
 #
-# Define SNPRINTF_RETURNS_BOGUS if your are on a system which snprintf()
-# or vsnprintf() return -1 instead of number of characters which would
-# have been written to the final string if enough space had been available.
-#
-# Define FREAD_READS_DIRECTORIES if your are on a system which succeeds
-# when attempting to read from an fopen'ed directory.
-#
 # Define CURLDIR=/foo/bar if your curl header and library files are in
 # /foo/bar/include and /foo/bar/lib directories.
 #
 # Define EXPATDIR=/foo/bar if your expat header and library files are in
 # /foo/bar/include and /foo/bar/lib directories.
 #
-# Define NO_D_INO_IN_DIRENT if you don't have d_ino in your struct dirent.
-#
-# Define NO_D_TYPE_IN_DIRENT if your platform defines DT_UNKNOWN but lacks
-# d_type in struct dirent (latest Cygwin -- will be fixed soonish).
-#
 # Define NO_C99_FORMAT if your formatted IO functions (printf/scanf et.al.)
 # do not support the 'size specifiers' introduced by C99, namely ll, hh,
 # j, z, t. (representing long long int, char, intmax_t, size_t, ptrdiff_t).
 # some C compilers supported these specifiers prior to C99 as an extension.
 #
-# Define NO_STRCASESTR if you don't have strcasestr.
-#
-# Define NO_MEMMEM if you don't have memmem.
-#
-# Define NO_STRTOUMAX if you don't have strtoumax in the C library.
-# If your compiler also does not support long long or does not have
-# strtoull, define NO_STRTOULL.
-#
-# Define NO_SETENV if you don't have setenv in the C library.
-#
-# Define NO_UNSETENV if you don't have unsetenv in the C library.
-#
-# Define NO_MKDTEMP if you don't have mkdtemp in the C library.
-#
-# Define NO_SYS_SELECT_H if you don't have sys/select.h.
-#
-# Define NO_FINK if you are building on Darwin/Mac OS X, have Fink
-# installed in /sw, but don't want PERF to link against any libraries
-# installed there.  If defined you may specify your own (or Fink's)
-# include directories and library directories by defining CFLAGS
-# and LDFLAGS appropriately.
-#
-# Define NO_DARWIN_PORTS if you are building on Darwin/Mac OS X,
-# have DarwinPorts installed in /opt/local, but don't want PERF to
-# link against any libraries installed there.  If defined you may
-# specify your own (or DarwinPort's) include directories and
-# library directories by defining CFLAGS and LDFLAGS appropriately.
-#
-# Define NEEDS_LIBICONV if linking with libc is not enough (Darwin).
-#
-# Define NEEDS_SOCKET if linking with libc is not enough (SunOS,
-# Patrick Mauritz).
-#
-# Define NO_MMAP if you want to avoid mmap.
-#
-# Define NO_PTHREADS if you do not have or do not want to use Pthreads.
-#
-# Define NO_PREAD if you have a problem with pread() system call (e.g.
-# cygwin.dll before v1.5.22).
-#
-# Define NO_TRUSTABLE_FILEMODE if your filesystem may claim to support
-# the executable mode bit, but doesn't really do so.
-#
-# Define NO_IPV6 if you lack IPv6 support and getaddrinfo().
-#
-# Define NO_SOCKADDR_STORAGE if your platform does not have struct
-# sockaddr_storage.
-#
-# Define NO_ICONV if your libc does not properly support iconv.
-#
-# Define OLD_ICONV if your library has an old iconv(), where the second
-# (input buffer pointer) parameter is declared with type (const char **).
-#
 # Define NO_DEFLATE_BOUND if your zlib does not have deflateBound.
 #
 # Define NO_R_TO_GCC_LINKER if your gcc does not like "-R/path/lib"
 # that tells runtime paths to dynamic libraries;
 # "-Wl,-rpath=/path/lib" is used instead.
 #
-# Define USE_NSEC below if you want perf to care about sub-second file mtimes
-# and ctimes. Note that you need recent glibc (at least 2.2.4) for this, and
-# it will BREAK YOUR LOCAL DIFFS! show-diff and anything using it will likely
-# randomly break unless your underlying filesystem supports those sub-second
-# times (my ext3 doesn't).
-#
-# Define USE_ST_TIMESPEC if your "struct stat" uses "st_ctimespec" instead of
-# "st_ctim"
-#
-# Define NO_NSEC if your "struct stat" does not have "st_ctim.tv_nsec"
-# available.  This automatically turns USE_NSEC off.
-#
-# Define NO_ST_BLOCKS_IN_STRUCT_STAT if your platform does not have st_blocks
-# field that counts the on-disk footprint in 512-byte blocks.
-#
 # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
 #
 # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
@@ -282,8 +202,6 @@ BASIC_LDFLAGS =
 # Guard against environment variables
 BUILTIN_OBJS =
 BUILT_INS =
-COMPAT_CFLAGS =
-COMPAT_OBJS =
 LIB_H =
 LIB_OBJS =
 PYRF_OBJS =
@@ -329,7 +247,7 @@ LANG_BINDINGS =
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
 # what 'all' will build but not install in perfexecdir
-OTHER_PROGRAMS = $(OUTPUT)perf$X
+OTHER_PROGRAMS = $(OUTPUT)perf
 
 # Set paths to tools early so that they can be used for version tests.
 ifndef SHELL_PATH
@@ -538,22 +456,6 @@ endif # NO_DWARF
 
 -include arch/$(ARCH)/Makefile
 
-ifeq ($(uname_S),Darwin)
-	ifndef NO_FINK
-		ifeq ($(shell test -d /sw/lib && echo y),y)
-			BASIC_CFLAGS += -I/sw/include
-			BASIC_LDFLAGS += -L/sw/lib
-		endif
-	endif
-	ifndef NO_DARWIN_PORTS
-		ifeq ($(shell test -d /opt/local/lib && echo y),y)
-			BASIC_CFLAGS += -I/opt/local/include
-			BASIC_LDFLAGS += -L/opt/local/lib
-		endif
-	endif
-	PTHREAD_LIBS =
-endif
-
 ifneq ($(OUTPUT),)
 	BASIC_CFLAGS += -I$(OUTPUT)
 endif
@@ -707,110 +609,9 @@ ifndef CC_LD_DYNPATH
 	endif
 endif
 
-ifdef NEEDS_SOCKET
-	EXTLIBS += -lsocket
-endif
-ifdef NEEDS_NSL
-	EXTLIBS += -lnsl
-endif
-ifdef NO_D_TYPE_IN_DIRENT
-	BASIC_CFLAGS += -DNO_D_TYPE_IN_DIRENT
-endif
-ifdef NO_D_INO_IN_DIRENT
-	BASIC_CFLAGS += -DNO_D_INO_IN_DIRENT
-endif
-ifdef NO_ST_BLOCKS_IN_STRUCT_STAT
-	BASIC_CFLAGS += -DNO_ST_BLOCKS_IN_STRUCT_STAT
-endif
-ifdef USE_NSEC
-	BASIC_CFLAGS += -DUSE_NSEC
-endif
-ifdef USE_ST_TIMESPEC
-	BASIC_CFLAGS += -DUSE_ST_TIMESPEC
-endif
-ifdef NO_NSEC
-	BASIC_CFLAGS += -DNO_NSEC
-endif
 ifdef NO_C99_FORMAT
 	BASIC_CFLAGS += -DNO_C99_FORMAT
 endif
-ifdef SNPRINTF_RETURNS_BOGUS
-	COMPAT_CFLAGS += -DSNPRINTF_RETURNS_BOGUS
-	COMPAT_OBJS += $(OUTPUT)compat/snprintf.o
-endif
-ifdef FREAD_READS_DIRECTORIES
-	COMPAT_CFLAGS += -DFREAD_READS_DIRECTORIES
-	COMPAT_OBJS += $(OUTPUT)compat/fopen.o
-endif
-ifdef NO_STRCASESTR
-	COMPAT_CFLAGS += -DNO_STRCASESTR
-	COMPAT_OBJS += $(OUTPUT)compat/strcasestr.o
-endif
-ifdef NO_STRTOUMAX
-	COMPAT_CFLAGS += -DNO_STRTOUMAX
-	COMPAT_OBJS += $(OUTPUT)compat/strtoumax.o
-endif
-ifdef NO_STRTOULL
-	COMPAT_CFLAGS += -DNO_STRTOULL
-endif
-ifdef NO_SETENV
-	COMPAT_CFLAGS += -DNO_SETENV
-	COMPAT_OBJS += $(OUTPUT)compat/setenv.o
-endif
-ifdef NO_MKDTEMP
-	COMPAT_CFLAGS += -DNO_MKDTEMP
-	COMPAT_OBJS += $(OUTPUT)compat/mkdtemp.o
-endif
-ifdef NO_UNSETENV
-	COMPAT_CFLAGS += -DNO_UNSETENV
-	COMPAT_OBJS += $(OUTPUT)compat/unsetenv.o
-endif
-ifdef NO_SYS_SELECT_H
-	BASIC_CFLAGS += -DNO_SYS_SELECT_H
-endif
-ifdef NO_MMAP
-	COMPAT_CFLAGS += -DNO_MMAP
-	COMPAT_OBJS += $(OUTPUT)compat/mmap.o
-else
-	ifdef USE_WIN32_MMAP
-		COMPAT_CFLAGS += -DUSE_WIN32_MMAP
-		COMPAT_OBJS += $(OUTPUT)compat/win32mmap.o
-	endif
-endif
-ifdef NO_PREAD
-	COMPAT_CFLAGS += -DNO_PREAD
-	COMPAT_OBJS += $(OUTPUT)compat/pread.o
-endif
-ifdef NO_TRUSTABLE_FILEMODE
-	BASIC_CFLAGS += -DNO_TRUSTABLE_FILEMODE
-endif
-ifdef NO_IPV6
-	BASIC_CFLAGS += -DNO_IPV6
-endif
-ifdef NO_UINTMAX_T
-	BASIC_CFLAGS += -Duintmax_t=uint32_t
-endif
-ifdef NO_SOCKADDR_STORAGE
-ifdef NO_IPV6
-	BASIC_CFLAGS += -Dsockaddr_storage=sockaddr_in
-else
-	BASIC_CFLAGS += -Dsockaddr_storage=sockaddr_in6
-endif
-endif
-ifdef NO_INET_NTOP
-	LIB_OBJS += $(OUTPUT)compat/inet_ntop.o
-endif
-ifdef NO_INET_PTON
-	LIB_OBJS += $(OUTPUT)compat/inet_pton.o
-endif
-
-ifdef NO_ICONV
-	BASIC_CFLAGS += -DNO_ICONV
-endif
-
-ifdef OLD_ICONV
-	BASIC_CFLAGS += -DOLD_ICONV
-endif
 
 ifdef NO_DEFLATE_BOUND
 	BASIC_CFLAGS += -DNO_DEFLATE_BOUND
@@ -819,14 +620,6 @@ endif
 ifdef NO_PERL_MAKEMAKER
 	export NO_PERL_MAKEMAKER
 endif
-ifdef NO_HSTRERROR
-	COMPAT_CFLAGS += -DNO_HSTRERROR
-	COMPAT_OBJS += $(OUTPUT)compat/hstrerror.o
-endif
-ifdef NO_MEMMEM
-	COMPAT_CFLAGS += -DNO_MEMMEM
-	COMPAT_OBJS += $(OUTPUT)compat/memmem.o
-endif
 ifdef INTERNAL_QSORT
 	COMPAT_CFLAGS += -DINTERNAL_QSORT
 	COMPAT_OBJS += $(OUTPUT)compat/qsort.o
@@ -835,9 +628,6 @@ ifdef RUNTIME_PREFIX
 	COMPAT_CFLAGS += -DRUNTIME_PREFIX
 endif
 
-ifdef DIR_HAS_BSD_GROUP_SEMANTICS
-	COMPAT_CFLAGS += -DDIR_HAS_BSD_GROUP_SEMANTICS
-endif
 ifdef NO_EXTERNAL_GREP
 	BASIC_CFLAGS += -DNO_EXTERNAL_GREP
 endif
@@ -895,9 +685,6 @@ PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
 
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
 
-BASIC_CFLAGS += $(COMPAT_CFLAGS)
-LIB_OBJS += $(COMPAT_OBJS)
-
 ALL_CFLAGS += $(BASIC_CFLAGS)
 ALL_CFLAGS += $(ARCH_CFLAGS)
 ALL_LDFLAGS += $(BASIC_LDFLAGS)
@@ -910,9 +697,6 @@ export TAR INSTALL DESTDIR SHELL_PATH
 SHELL = $(SHELL_PATH)
 
 all:: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(BUILT_INS) $(OTHER_PROGRAMS) $(OUTPUT)PERF-BUILD-OPTIONS
-ifneq (,$X)
-	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), test '$p' -ef '$p$X' || $(RM) '$p';)
-endif
 
 all::
 
@@ -921,15 +705,15 @@ please_set_SHELL_PATH_to_a_more_modern_shell:
 
 shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
 
-strip: $(PROGRAMS) $(OUTPUT)perf$X
-	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf$X
+strip: $(PROGRAMS) $(OUTPUT)perf
+	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -DPERF_VERSION='"$(PERF_VERSION)"' \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
-$(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
@@ -1027,11 +811,11 @@ $(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/tra
 $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
-$(OUTPUT)perf-%$X: %.o $(PERFLIBS)
+$(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
-$(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
+$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
@@ -1168,7 +952,7 @@ export perfexec_instdir
 
 install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) $(OUTPUT)perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
@@ -1267,7 +1051,7 @@ distclean: clean
 
 clean:
 	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
-	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf$X
+	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf
 	$(RM) $(TEST_PROGRAMS)
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(RM) -r $(PERF_TARNAME) .doc-tmp-dir
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index e833f26..fc78428 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -70,9 +70,7 @@
 #include <sys/poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
-#ifndef NO_SYS_SELECT_H
 #include <sys/select.h>
-#endif
 #include <netinet/in.h>
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
@@ -83,10 +81,6 @@
 #include "types.h"
 #include <sys/ttydefaults.h>
 
-#ifndef NO_ICONV
-#include <iconv.h>
-#endif
-
 extern const char *graph_line;
 extern const char *graph_dotted_line;
 extern char buildid_dir[];
@@ -236,26 +230,6 @@ static inline int sane_case(int x, int high)
 	return x;
 }
 
-#ifndef DIR_HAS_BSD_GROUP_SEMANTICS
-# define FORCE_DIR_SET_GID S_ISGID
-#else
-# define FORCE_DIR_SET_GID 0
-#endif
-
-#ifdef NO_NSEC
-#undef USE_NSEC
-#define ST_CTIME_NSEC(st) 0
-#define ST_MTIME_NSEC(st) 0
-#else
-#ifdef USE_ST_TIMESPEC
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctimespec.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtimespec.tv_nsec))
-#else
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctim.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtim.tv_nsec))
-#endif
-#endif
-
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 
-- 
1.6.2.5

