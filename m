Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0IVJDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:03:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0IVJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:03:41 -0400
Date: Wed, 22 Sep 2010 11:03:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf build fixes for opensuse 10.0
Message-ID: <20100922090336.GA5338@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the perf Makefile to compile on opensuse 10.0

-Werror in shipping code is usually a bad idea. Remove that.
Also remove warning options that are not supported in older compilers.
And fix a missing include for __always_inline.
    
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4f1fa77..1bf4d9c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -201,13 +201,13 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
+#EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
+#EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
@@ -224,7 +224,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index bb4ac2e..305f1c2 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -2,6 +2,7 @@
 #define _PERF_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <asm/hweight.h>
 
 #define BITS_PER_LONG __WORDSIZE
