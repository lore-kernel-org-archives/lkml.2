Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1EFAZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:35 -0400
Received: from kroah.org ([198.145.64.141]:37089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab1EFAZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.781469261@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [097/143] perf tools: Test -fstack-protector-all compiler option for inclusion in CFLAGS
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Cree <mcree@orcon.net.nz>

commit 5d7bdab75cd56d2bdc0986ae5546be3b09fea70a upstream.

Some architectures (e.g. Alpha) do not support the
-fstack-protector-all compiler option and the use of the option
with -Werror causes the compiler to abort and the build fails.

Test that the compiler supports -fstack-protector-all before
inclusion in CFLAGS.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091111074302.GA3728@omega>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -207,7 +207,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -261,6 +261,9 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null >/dev/null 2>&1 && echo y"), y)
+  CFLAGS := $(CFLAGS) -fstack-protector-all
+endif
 
 
 ### --- END CONFIGURATION SECTION ---


