Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0ITWpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:45:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:13406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0ITWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:45:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=QfqWtCwyU8m13Nwarx7/JoHhYbLIYGja31B56iVkm0shy1fFUHALmtLeHB64uD3K6
	Stg1KDJWROhfi+Uxc2jlA==
Message-ID: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 21 Sep 2010 00:45:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: fix extern struct definitions
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both python_scripting_ops and perl_scripting_ops have two global definitions.
One in trace-event-scripting.c and one in their respective scripting-engine
modules.

The issue is that depending on the linker order one definition or the other
is chosen. One is uninitialized (bss), while the other is initialized. If
the uninitialized version is chosen, then perf does not function properly.

This patch fixes this by adding the extern prefix to the definitions in
trace-event-scripting.c. 

Signed-off-by: Stephane Eranian <eranian@google.com>

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
