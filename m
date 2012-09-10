Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2IJWS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:18:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34810 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2IJWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:18:57 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 3/6] perf tools: include __WORDSIZE definition
Date: Tue, 11 Sep 2012 01:15:00 +0300
Message-Id: <1347315303-29906-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347315303-29906-1-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Pekka Enberg <penberg@kernel.org>
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
1.7.9.5

