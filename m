Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1EFAo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:44:59 -0400
Received: from kroah.org ([198.145.64.141]:37130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab1EFAZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:15 2011
Message-Id: <20110506002215.176336082@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [101/143] perf: Use default compiler mode by default
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 81516c5fc83a13a1d12f466aa7e14f5fd62a63ce upstream.

gcc with no flags typically is a sane default for systems to
use, and looking at the running kernel is probably broken for
cross-builds anyway, so let's not do this.  Add EXTRA_CFLAGS so
that users can override default gcc mode if they want to.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091122121335.GA24254@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -148,6 +148,8 @@ all::
 # broken, or spawning external process is slower than built-in grep perf has).
 #
 # Define LDFLAGS=-static to build a static binary.
+#
+# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
@@ -160,20 +162,6 @@ uname_R := $(shell sh -c 'uname -r 2>/de
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-#
-# Add -m32 for cross-builds:
-#
-ifdef NO_64BIT
-  MBITS := -m32
-else
-  #
-  # If we're on a 64-bit kernel, use -m64:
-  #
-  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-    MBITS := -m64
-  endif
-endif
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -210,7 +198,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)


