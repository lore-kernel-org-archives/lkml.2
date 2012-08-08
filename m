Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030676Ab2HHRRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:17:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54090 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030570Ab2HHRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:13:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: =?UTF-8?q?=5BPATCH=2006/11=5D=20perf=20list=3A=20Document=20precise=20event=20sampling=20for=20AMD=20IBS?=
Date: Wed,  8 Aug 2012 14:13:43 -0300
Message-Id: <1344446028-21381-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344446028-21381-1-git-send-email-acme@infradead.org>
References: <1344446028-21381-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Updating man perf-list.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-7-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   42 +++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 232be51..d1e39dc 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -20,20 +20,38 @@ EVENT MODIFIERS
 ---------------
 
 Events can optionally have a modifer by appending a colon and one or
-more modifiers.  Modifiers allow the user to restrict when events are
-counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
-Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
-for host counting (not in KVM guests).
+more modifiers. Modifiers allow the user to restrict the events to be
+counted. The following modifiers exist:
+
+ u - user-space counting
+ k - kernel counting
+ h - hypervisor counting
+ G - guest counting (in KVM guests)
+ H - host counting (not in KVM guests)
+ p - precise level
 
 The 'p' modifier can be used for specifying how precise the instruction
-address should be. The 'p' modifier is currently only implemented for
-Intel PEBS and can be specified multiple times:
-  0 - SAMPLE_IP can have arbitrary skid
-  1 - SAMPLE_IP must have constant skid
-  2 - SAMPLE_IP requested to have 0 skid
-  3 - SAMPLE_IP must have 0 skid
+address should be. The 'p' modifier can be specified multiple times:
+
+ 0 - SAMPLE_IP can have arbitrary skid
+ 1 - SAMPLE_IP must have constant skid
+ 2 - SAMPLE_IP requested to have 0 skid
+ 3 - SAMPLE_IP must have 0 skid
+
+For Intel systems precise event sampling is implemented with PEBS
+which supports up to precise-level 2.
+
+On AMD systems it is implemented using IBS (up to precise-level 2).
+The precise modifier works with event types 0x76 (cpu-cycles, CPU
+clocks not halted) and 0xC1 (micro-ops retired). Both events map to
+IBS execution sampling (IBS op) with the IBS Op Counter Control bit
+(IbsOpCntCtl) set respectively (see AMD64 Architecture Programmer’s
+Manual Volume 2: System Programming, 13.3 Instruction-Based
+Sampling). Examples to use IBS:
 
-The PEBS implementation now supports up to 2.
+ perf record -a -e cpu-cycles:p ...    # use ibs op counting cycles
+ perf record -a -e r076:p ...          # same as -e cpu-cycles:p
+ perf record -a -e r0C1:p ...          # use ibs op counting micro-ops
 
 RAW HARDWARE EVENT DESCRIPTOR
 -----------------------------
@@ -97,4 +115,4 @@ SEE ALSO
 linkperf:perf-stat[1], linkperf:perf-top[1],
 linkperf:perf-record[1],
 http://www.intel.com/Assets/PDF/manual/253669.pdf[Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide],
-http://support.amd.com/us/Processor_TechDocs/24593.pdf[AMD64 Architecture Programmer’s Manual Volume 2: System Programming]
+http://support.amd.com/us/Processor_TechDocs/24593_APM_v2.pdf[AMD64 Architecture Programmer’s Manual Volume 2: System Programming]
-- 
1.7.9.2.358.g22243

