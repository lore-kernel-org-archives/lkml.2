Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0EQWeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:34:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:56017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0EQWeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:34:04 -0400
Date: Mon, 17 May 2010 22:33:39 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add mode to build without newt support
Message-ID: <tip-94f3ca95787ada3d64339a4ecb2754236ab563f6@git.kernel.org>
Git-Commit-ID: 94f3ca95787ada3d64339a4ecb2754236ab563f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 22:33:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94f3ca95787ada3d64339a4ecb2754236ab563f6
Gitweb:     http://git.kernel.org/tip/94f3ca95787ada3d64339a4ecb2754236ab563f6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 17 May 2010 18:18:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 May 2010 18:18:11 -0300

perf tools: Add mode to build without newt support

make NO_NEWT=1

Will avoid building the newt (tui) support.

Suggested-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e2729fc..3d8f31e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -558,6 +558,9 @@ else
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
+ifdef NO_NEWT
+	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
+else
 ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtInit(); newtCls(); return newtFinished(); }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -lnewt -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
@@ -567,6 +570,7 @@ else
 	EXTLIBS += -lnewt -lslang
 	LIB_OBJS += $(OUTPUT)util/newt.o
 endif
+endif # NO_NEWT
 
 ifndef NO_LIBPERL
 PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
