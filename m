Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0JDSy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:54:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab0JDSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:54:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf trace scripting: Fix extern struct definitions
Date: Mon,  4 Oct 2010 15:54:43 -0300
Message-Id: <1286218483-7219-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1286218483-7219-1-git-send-email-acme@infradead.org>
References: <1286218483-7219-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Both python_scripting_ops and perl_scripting_ops have two global definitions.
One in trace-event-scripting.c and one in their respective scripting-engine
modules.

The issue is that depending on the linker order one definition or the other
is chosen. One is uninitialized (bss), while the other is initialized. If
the uninitialized version is chosen, then perf does not function properly.

This patch fixes this by adding the extern prefix to the definitions in
trace-event-scripting.c.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-scripting.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 7ea983a..f7af2fc 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -97,7 +97,7 @@ void setup_python_scripting(void)
 	register_python_scripting(&python_scripting_unsupported_ops);
 }
 #else
-struct scripting_ops python_scripting_ops;
+extern struct scripting_ops python_scripting_ops;
 
 void setup_python_scripting(void)
 {
@@ -158,7 +158,7 @@ void setup_perl_scripting(void)
 	register_perl_scripting(&perl_scripting_unsupported_ops);
 }
 #else
-struct scripting_ops perl_scripting_ops;
+extern struct scripting_ops perl_scripting_ops;
 
 void setup_perl_scripting(void)
 {
-- 
1.6.2.5

