Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3AHOJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:09:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:35336 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3AHOJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:09:06 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] tools/perf: let it build from perf-*-src-pkg
Date: Tue,  8 Jan 2013 15:08:54 +0100
Message-Id: <1357654134-28538-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks (mostly) to uapi the package created from perf-*-src-pkg FTBFS:

|    CC perf.o
|In file included from util/../perf.h:8:0,
|                 from util/cache.h:7,
|                 from perf.c:12:
|arch/x86/include/asm/unistd.h:4:29: fatal error: uapi/asm/unistd.h: No such file or directory
|
|    CC perf.o
|In file included from util/../perf.h:106:0,
|                 from util/cache.h:7,
|                 from perf.c:12:
|include/linux/perf_event.h:17:35: fatal error: uapi/linux/perf_event.h: No such file or directory
|
|    CC perf.o
|In file included from include/uapi/linux/perf_event.h:19:0,
|                 from util/../perf.h:106,
|                 from util/cache.h:7,
|                 from perf.c:12:
|util/include/asm/byteorder.h:2:49: fatal error: ../../../../include/uapi/linux/swab.h: No such file or directory
|
|    CC perf.o
|In file included from util/include/../../../../include/linux/list.h:7:0,
|                 from util/include/linux/list.h:4,
|                 from util/parse-events.h:7,
|                 from perf.c:15:
|util/include/linux/const.h:1:50: fatal error: ../../../../include/uapi/linux/const.h: No such file or directory
|
|In file included from builtin-kvm.c:26:0:
|arch/x86/include/asm/svm.h:4:26: fatal error: uapi/asm/svm.h: No such file or directory
|
|In file included from util/evsel.c:21:0:
|include/linux/hw_breakpoint.h:5:38: fatal error: uapi/linux/hw_breakpoint.h: No such file or directory
|
|    CC util/evsel.o
|In file included from util/perf_regs.h:5:0,
|                 from util/evsel.c:23:
|arch/x86/include/perf_regs.h:6:27: fatal error: asm/perf_regs.h: No such file or directory
|
|   CC util/rbtree.o
|In file included from ../../lib/rbtree.c:24:0:
|util/include/linux/rbtree_augmented.h:2:56: fatal error: ../../../../include/linux/rbtree_augmented.h: No such file or directory

This patch adds the missing files.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

  sort tools/perf/MANIFEST > MANIFEST && mv MANIFEST tools/perf/MANIFEST

?

 tools/perf/MANIFEST |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 80db3f4..39d4106 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -11,11 +11,21 @@ lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
 arch/*/include/asm/perf_regs.h
+arch/*/include/uapi/asm/unistd*.h
+arch/*/include/uapi/asm/perf_regs.h
 arch/*/lib/memcpy*.S
 arch/*/lib/memset*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
+include/linux/rbtree_augmented.h
+include/uapi/linux/perf_event.h
+include/uapi/linux/const.h
+include/uapi/linux/swab.h
+include/uapi/linux/hw_breakpoint.h
 arch/x86/include/asm/svm.h
 arch/x86/include/asm/vmx.h
 arch/x86/include/asm/kvm_host.h
+arch/x86/include/uapi/asm/svm.h
+arch/x86/include/uapi/asm/vmx.h
+arch/x86/include/uapi/asm/kvm.h
-- 
1.7.10.4

