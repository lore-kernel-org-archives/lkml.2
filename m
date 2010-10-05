Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0JEMOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:14:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:45448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab0JEMOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:14:35 -0400
Date: Tue, 5 Oct 2010 12:13:46 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, davem@davemloft.net, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, davem@davemloft.net, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
References: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace scripting: Fix extern struct definitions
Message-ID: <tip-0f940cb7d970f4fd569bb5f9f49774422f2ccbee@git.kernel.org>
Git-Commit-ID: 0f940cb7d970f4fd569bb5f9f49774422f2ccbee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 12:13:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f940cb7d970f4fd569bb5f9f49774422f2ccbee
Gitweb:     http://git.kernel.org/tip/0f940cb7d970f4fd569bb5f9f49774422f2ccbee
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 21 Sep 2010 00:45:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Oct 2010 12:24:51 -0300

perf trace scripting: Fix extern struct definitions

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
