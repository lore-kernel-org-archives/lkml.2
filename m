Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1C3WqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:46:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:51390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab1C3WqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:46:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf script: Add more documentation about the -f/--fields parameters
Date: Wed, 30 Mar 2011 19:46:11 -0300
Message-Id: <1301525171-5094-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301525171-5094-1-git-send-email-acme@infradead.org>
References: <1301525171-5094-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using the commit log for 2c9e45f.

Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |   52 ++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 66f040b..86c87e2 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -113,13 +113,61 @@ OPTIONS
         Do various checks like samples ordering and lost events.
 
 -f::
---fields
+--fields::
         Comma separated list of fields to print. Options are:
         comm, tid, pid, time, cpu, event, trace, sym. Field
-        list must be prepended with the type, trace, sw or hw,
+        list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
 
+		perf script -f <fields>
+
+	is equivalent to:
+
+		perf script -f trace:<fields> -f sw:<fields> -f hw:<fields>
+    
+	i.e., the specified fields apply to all event types if the type string
+	is not given.
+    
+	The arguments are processed in the order received. A later usage can
+	reset a prior request. e.g.:
+    
+		-f trace: -f comm,tid,time,sym
+    
+	The first -f suppresses trace events (field list is ""), but then the
+	second invocation sets the fields to comm,tid,time,sym. In this case a
+	warning is given to the user:
+    
+		"Overriding previous field request for all events."
+    
+	Alternativey, consider the order:
+    
+		-f comm,tid,time,sym -f trace:
+    
+	The first -f sets the fields for all events and the second -f
+	suppresses trace events. The user is given a warning message about
+	the override, and the result of the above is that only S/W and H/W
+	events are displayed with the given fields.
+    
+	For the 'wildcard' option if a user selected field is invalid for an
+	event type, a message is displayed to the user that the option is
+	ignored for that type. For example:
+    
+		$ perf script -f comm,tid,trace
+		'trace' not valid for hardware events. Ignoring.
+		'trace' not valid for software events. Ignoring.
+    
+	Alternatively, if the type is given an invalid field is specified it
+	is an error. For example:
+    
+        perf script -v -f sw:comm,tid,trace
+        'trace' not valid for software events.
+    
+	At this point usage is displayed, and perf-script exits.
+    
+	Finally, a user may not set fields to none for all event types.
+	i.e., -f "" is not allowed.
+
 -k::
 --vmlinux=<file>::
         vmlinux pathname
-- 
1.6.2.5

