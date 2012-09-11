Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2IKXz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:55:59 -0400
Received: from [205.233.59.134] ([205.233.59.134]:37417 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2IKXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:54:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/18] perf tools: include __WORDSIZE definition
Date: Tue, 11 Sep 2012 20:52:59 -0300
Message-Id: <1347407590-30960-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@gmail.com>

__WORDSIZE is GLibC-specific and is not defined on all systems or glibc
versions (e.g. Android's bionic does not define it).

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

Defining __WORDSIZE in perf's headers if it is not already defined.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-4-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 587a230..a55d8cf 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -5,6 +5,10 @@
 #include <linux/compiler.h>
 #include <asm/hweight.h>
 
+#ifndef __WORDSIZE
+#define __WORDSIZE (__SIZEOF_LONG__ * 8)
+#endif
+
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-- 
1.7.9.2.358.g22243

