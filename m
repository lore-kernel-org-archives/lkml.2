Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0CQWES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0CQWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:04:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] perf probe: Add NO_DWARF make option
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 17 Mar 2010 18:12:00 -0400
Message-ID: <20100317221200.23088.7662.stgit@localhost6.localdomain6>
In-Reply-To: <20100317221152.23088.64591.stgit@localhost6.localdomain6>
References: <20100317221152.23088.64591.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NO_DWARF make option for testing build without libdw.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Masami Hiramatsu
e-mail: mhiramat@redhat.com
