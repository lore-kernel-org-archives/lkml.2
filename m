Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0CYW7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:59:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0CYW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:59:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/6] perf tools: Move __used from perf.h to linux/compiler.h
Date: Thu, 25 Mar 2010 19:58:59 -0300
Message-Id: <1269557941-15617-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269557941-15617-1-git-send-email-acme@infradead.org>
References: <1269557941-15617-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like in the kernel and also to remove the need to include perf.h
in the symbol subsystem.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h                        |    2 --
 tools/perf/util/include/linux/compiler.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index aa78615..ec21274 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -106,8 +106,6 @@ static inline unsigned long long rdclock(void)
 #define __user
 #define asmlinkage
 
-#define __used		__attribute__((__unused__))
-
 #define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index dfb0713..791f9dd 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -7,4 +7,6 @@
 #define __user
 #define __attribute_const__
 
+#define __used		__attribute__((__unused__))
+
 #endif
-- 
1.6.2.5

