Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1ADP36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:29:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:11788 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1ADP34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=Jhq+tTaSfi95w5JjXebVOj0/EDRh/qzLU1KAoDbIrKPon7iSH9jDVwm7jIf7uDuxnZ
         GPgVS5EhGVzPBKlxZmbg==
Message-ID: <4d233cf0.2308e30a.7b00.ffffc187@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 4 Jan 2011 16:30:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: fix perf_event.h header usage
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the usage of the perf_event.h header file
between command modules and the supporting code in util.

It is necessary to ensure that ALL files use the SAME
perf_event.h header from the kernel source tree.

There were a couple of #include <linux/perf_event.h> mixed
with #include "../../perf_event.h".

This caused issues on some distros because of mismatch
in the layout of struct perf_event_attr. That eventually
led perf stat to segfault.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 863d78d..a0ccd69 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
  
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1c9043c..b82cafb 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,7 @@
  * Parse symbolic events/counts passed in as options:
  */
 
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 
 struct list_head;
 struct perf_evsel;
