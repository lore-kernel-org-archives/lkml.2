Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0CVS4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:56:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:56243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0CVS4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:56:07 -0400
Date: Mon, 22 Mar 2010 18:55:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1269274229-20442-3-git-send-email-acme@infradead.org>
References: <1269274229-20442-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Add NO_DWARF make option
Message-ID: <tip-ca721e45b39209415d2288dbac3667b26d9d1def@git.kernel.org>
Git-Commit-ID: ca721e45b39209415d2288dbac3667b26d9d1def
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Mar 2010 18:55:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca721e45b39209415d2288dbac3667b26d9d1def
Gitweb:     http://git.kernel.org/tip/ca721e45b39209415d2288dbac3667b26d9d1def
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 22 Mar 2010 13:10:27 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Mar 2010 18:47:35 +0100

perf probe: Add NO_DWARF make option

Add NO_DWARF make option for testing build without libdw.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1269274229-20442-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c991818..6903645 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -150,6 +150,8 @@ all::
 # Define LDFLAGS=-static to build a static binary.
 #
 # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
+#
+# Define NO_DWARF if you do not want debug-info analysis feature at all.
 
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
@@ -507,10 +509,12 @@ endif
 ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
 else
+ifndef NO_DWARF
 	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += util/probe-finder.o
 endif
+endif
 
 ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtInit(); newtCls(); return newtFinished(); }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -lnewt -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
