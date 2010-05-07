Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0EGSkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:40:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0EGSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:40:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/1] perf list: Improve the raw hw event descriptor documentation
Date: Fri,  7 May 2010 15:40:28 -0300
Message-Id: <1273257628-15215-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273257628-15215-1-git-send-email-acme@infradead.org>
References: <1273257628-15215-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was x86 specific and imcomplete at that, improve the situation by
making it clear where the example provided applies and by adding the
URLs for the Intel and AMD manuals where this is discussed in depth.

Acked-by: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Reported-by: Robert Richter <robert.richter@amd.com
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   19 ++++++++++++++++---
 tools/perf/util/parse-events.c         |    3 ++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index ad765e0..43e3dd2 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -18,8 +18,16 @@ various perf commands with the -e option.
 RAW HARDWARE EVENT DESCRIPTOR
 -----------------------------
 Even when an event is not available in a symbolic form within perf right now,
-it can be encoded as <UMASK VALUE><EVENT NUM>, for instance, if the Intel docs
-describe an event as:
+it can be encoded in a per processor specific way.
+
+For instance For x86 CPUs NNN represents the raw register encoding with the
+layout of IA32_PERFEVTSELx MSRs (see [Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide] Figure 30-1 Layout
+of IA32_PERFEVTSELx MSRs) or AMD's PerfEvtSeln (see [AMD64 Architecture Programmer’s Manual Volume 2: System Programming], Page 344,
+Figure 13-7 Performance Event-Select Register (PerfEvtSeln)).
+
+Example:
+
+If the Intel docs for a QM720 Core i7 describe an event as:
 
   Event  Umask  Event Mask
   Num.   Value  Mnemonic    Description                        Comment
@@ -33,6 +41,9 @@ raw encoding of 0x1A8 can be used:
  perf stat -e r1a8 -a sleep 1
  perf record -e r1a8 ...
 
+You should refer to the processor specific documentation for getting these
+details. Some of them are referenced in the SEE ALSO section below.
+
 OPTIONS
 -------
 None
@@ -40,4 +51,6 @@ None
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-top[1],
-linkperf:perf-record[1]
+linkperf:perf-record[1],
+http://www.intel.com/Assets/PDF/manual/253669.pdf[Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide],
+http://support.amd.com/us/Processor_TechDocs/24593.pdf[AMD64 Architecture Programmer’s Manual Volume 2: System Programming]
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bc8b7e6..7b24b5d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -936,7 +936,8 @@ void print_events(void)
 
 	printf("\n");
 	printf("  %-42s [%s]\n",
-		"rNNN (NNN=<UMASK VALUE><EVENT NUM>)", event_type_descriptors[PERF_TYPE_RAW]);
+		"rNNN (see 'perf list --help' on how to encode it)",
+	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
 	printf("  %-42s [%s]\n",
-- 
1.6.2.5

