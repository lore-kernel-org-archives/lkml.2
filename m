Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437Ab2IHCHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:07:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41328 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab2IHCH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/13] perf tools: include basename for non-glibc systems
Date: Fri,  7 Sep 2012 23:07:06 -0300
Message-Id: <1347070032-4161-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

perf uses the glibc version of basename(), by defining _GNU_SOURCE,
including string.h and not including libgen.h. The glibc version of
basename is better than the POSIX version since it does not modify its
argument.

Android has only one version of basename which is defined in libgen.h.
This version is the same as the glibc version.

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
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-6-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.9.2.358.g22243

