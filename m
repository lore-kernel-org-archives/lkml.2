Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1EFAZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:43 -0400
Received: from kroah.org ([198.145.64.141]:37144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab1EFAZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:15 2011
Message-Id: <20110506002215.264240607@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-15?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= 
	<fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [102/143] perf tools: Move QUIET_STDERR def to before first use
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 830395188fae5f4028fa3c38ab1b031aae18a64c upstream.

QUIET_STDERR is used when detecting if -fstack-protector-all can
be used.

Noticed while building the perf tools on a Debian PARISC64
machine.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1263293910-8484-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -252,6 +252,12 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(V), 2)
+	QUIET_STDERR = ">/dev/null"
+else
+	QUIET_STDERR = ">/dev/null 2>&1"
+endif
+
 ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null "$(QUIET_STDERR)" && echo y"), y)
   CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
@@ -397,11 +403,6 @@ BUILTIN_OBJS += builtin-trace.o
 
 PERFLIBS = $(LIB_FILE)
 
-ifeq ($(V), 2)
-	QUIET_STDERR = ">/dev/null"
-else
-	QUIET_STDERR = ">/dev/null 2>&1"
-endif
 #
 # Platform specific tweaks
 #


