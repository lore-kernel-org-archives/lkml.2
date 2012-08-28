Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2H1WEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:04:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2H1WEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:04:32 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:04:11 +0300
Message-ID: <CANg8OW+nk0b4GtUw0uTP0nPi+4sA1K70uxhZ_v-9+76v-B5e2A@mail.gmail.com>
Subject: [PATCH 06/13] perf tools: include basename for non-glibc systems
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf uses the glibc version of basename(), by defining
_GNU_SOURCE, including string.h and not including libgen.h.
The glibc version of basename is better than the POSIX
version since it does not modify its argument.

Android has only one version of basename which is defined in
libgen.h. This version is the same as the glibc version.

Error on Android:
util/annotate.c: In function 'symbol__annotate_printf':
util/annotate.c:503:3: error: implicit declaration of function 'basename'
[-Werror=implicit-function-declaration]
util/annotate.c:503:3: error: nested extern declaration of 'basename'
[-Werror=nested-externs]
util/annotate.c:503:14: error: assignment makes pointer from integer without
a cast [-Werror]

On Android libgen.h should be included to define basename.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/symbol.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fc4b1e6..d3b330c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,6 +10,9 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <byteswap.h>
+#if defined(__BIONIC__)
+#include <libgen.h>
+#endif

 #ifndef NO_LIBELF_SUPPORT
 #include <libelf.h>
--
1.7.9.5
