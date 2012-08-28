Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2H1WCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:02:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2H1WCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:02:36 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:02:16 +0300
Message-ID: <CANg8OW+DcjMK_qxuh8pHOjY7imOCVi0JQUXML7qHPbhPQAdioA@mail.gmail.com>
Subject: [PATCH 04/13] perf tools: include __WORDSIZE definition
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

__WORDSIZE is GLibC-specific and is not defined
on all systems or glibc versions (e.g. Android's
bionic does not define it).

In file included from util/include/linux/bitmap.h:5:0,
                 from util/header.h:10,
                 from util/session.h:6,
                 from util/build-id.h:4,
                 from util/annotate.c:11:
util/include/linux/bitops.h: In function 'set_bit':
util/include/linux/bitops.h:25:12: error:
'__WORDSIZE' undeclared (first use in this function)
util/include/linux/bitops.h:25:12: note:
each undeclared identifier is reported only once for each function it appears in
util/include/linux/bitops.h:23:51: error:
parameter 'addr' set but not used [-Werror=unused-but-set-parameter]
util/include/linux/bitops.h: In function 'clear_bit':
util/include/linux/bitops.h:30:12: error:
'__WORDSIZE' undeclared (first use in this function)
util/include/linux/bitops.h:28:53: error:
parameter 'addr' set but not used [-Werror=unused-but-set-parameter]
In file included from util/header.h:10:0,
                 from util/session.h:6,
                 from util/build-id.h:4,
                 from util/annotate.c:11:
util/include/linux/bitmap.h: In function 'bitmap_zero':
util/include/linux/bitmap.h:22:6: error:
'__WORDSIZE' undeclared (first use in this function)

Defining __WORDSIZE in perf's headers if it is
not already defined.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/include/linux/bitops.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/include/linux/bitops.h
b/tools/perf/util/include/linux/bitops.h
index 587a230..91779ec 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -5,6 +5,15 @@
 #include <linux/compiler.h>
 #include <asm/hweight.h>

+#ifndef __WORDSIZE
+#if defined(__x86_64__)
+# define __WORDSIZE 64
+#endif
+#if defined(__i386__) || defined(__arm__)
+# define __WORDSIZE 32
+#endif
+#endif
+
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
--
1.7.9.5
