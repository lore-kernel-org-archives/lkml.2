Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0HQX0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:26:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:33650 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab0HQXX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:27 -0400
Message-Id: <20100817232152.354693489@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 09/20] x86: inline memcpy
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=x86-inline-memcpy.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export an inline_memcpy() API. Useful when the memcpy size is unknown but the
caller cannot afford the cost of a function call. Useful for very frequent
memcpy callers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/x86/include/asm/string_32.h |    7 +++++++
 arch/x86/include/asm/string_64.h |    7 +++++++
 2 files changed, 14 insertions(+)

Index: linux.trees.git/arch/x86/include/asm/string_32.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/string_32.h	2010-06-21 17:50:21.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/string_32.h	2010-06-21 17:56:49.000000000 -0400
@@ -44,6 +44,13 @@ static __always_inline void *__memcpy(vo
 	return to;
 }
 
+#define __HAVE_ARCH_INLINE_MEMCPY
+static __always_inline void *inline_memcpy(void *to, const void *from,
+					   size_t n)
+{
+	return __memcpy(to, from, n);
+}
+
 /*
  * This looks ugly, but the compiler can optimize it totally,
  * as the count is constant.
Index: linux.trees.git/arch/x86/include/asm/string_64.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/string_64.h	2010-06-21 17:50:21.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/string_64.h	2010-06-21 17:57:13.000000000 -0400
@@ -23,6 +23,13 @@ static __always_inline void *__inline_me
 	return to;
 }
 
+#define __HAVE_ARCH_INLINE_MEMCPY
+static __always_inline void *inline_memcpy(void *to, const void *from,
+					   size_t n)
+{
+	return __inline_memcpy(to, from, n);
+}
+
 /* Even with __builtin_ the compiler may decide to use the out of line
    function. */
 

