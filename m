Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1HRQuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:50:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1HRQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:50:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf tools: Fix build against newer glibc
Date: Thu, 18 Aug 2011 13:50:02 -0300
Message-Id: <1313686204-30295-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313686204-30295-1-git-send-email-acme@infradead.org>
References: <1313686204-30295-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

Upstream glibc commit 295e904 added a definition for __attribute_const__
to cdefs.h.  This causes the following error when building perf:

util/include/linux/compiler.h:8:0: error: "__attribute_const__"
redefined [-Werror] /usr/include/sys/cdefs.h:226:0: note: this is the
location of the previous definition

Wrap __attribute_const__ in #ifndef as we do for __always_inline.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110818113720.GL2227@zod.bos.redhat.com
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/compiler.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..547628e 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -5,7 +5,9 @@
 #define __always_inline	inline
 #endif
 #define __user
+#ifndef __attribute_const__
 #define __attribute_const__
+#endif
 
 #define __used		__attribute__((__unused__))
 
-- 
1.6.2.5

