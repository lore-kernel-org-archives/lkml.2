Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab1EFAZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:37 -0400
Received: from kroah.org ([198.145.64.141]:37078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab1EFAZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.659257274@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [096/143] perf tools: Add make DEBUG=1 to remove the -O6 cflag
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 60d526f7fa6246b8e32d5b45610d625a5608d988 upstream.

When using gdb to debug perf, it is practically impossible to
use when perf is compiled with -O6. For developers, this patch
adds the DEBUG feature to the make command line so that a
developer can easily remove the optimization flag.

LKML-Reference: <1255590330.8392.446.camel@twins>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091020232033.984323261@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -200,7 +200,14 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wol
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+ifeq ("$(origin DEBUG)", "command line")
+  PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+  CFLAGS_OPTIMIZE = -O6
+endif
+
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)


