Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0CVQKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:10:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0CVQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:10:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf probe: Add NO_DWARF make option
Date: Mon, 22 Mar 2010 13:10:27 -0300
Message-Id: <1269274229-20442-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269274229-20442-1-git-send-email-acme@infradead.org>
References: <1269274229-20442-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add NO_DWARF make option for testing build without libdw.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

