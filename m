Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0D0M7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:59:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0D0M7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:59:47 -0400
Date: Tue, 27 Apr 2010 12:59:19 GMT
From: tip-bot for Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, stefanha@linux.vnet.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, stefanha@linux.vnet.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix libdw-dev package name in error message
Message-ID: <tip-f93830fbb06b67848c762f2177c06cc3cbb97deb@git.kernel.org>
Git-Commit-ID: f93830fbb06b67848c762f2177c06cc3cbb97deb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:59:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f93830fbb06b67848c762f2177c06cc3cbb97deb
Gitweb:     http://git.kernel.org/tip/f93830fbb06b67848c762f2177c06cc3cbb97deb
Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
AuthorDate: Mon, 26 Apr 2010 15:39:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Apr 2010 15:39:54 -0300

perf tools: Fix libdw-dev package name in error message

The headers required for DWARF support are provided by the libdw-dev
package in Debian-based distros.  This patch corrects the elfutils-dev
package name to libdw-dev in the Makefile error message when libdw.h is
not found.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e8bf2e1..3ac6b67 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -504,7 +504,7 @@ PERFLIBS = $(LIB_FILE)
 
 ifndef NO_DWARF
 ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
+	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/libdw-dev);
 	NO_DWARF := 1
 endif # Dwarf support
 endif # NO_DWARF
