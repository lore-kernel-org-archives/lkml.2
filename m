Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2HUPaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:30:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2HUPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:30:16 -0400
Date: Tue, 21 Aug 2012 08:29:59 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-2055fdaf8703d3101b12e0d9b7cbceaeabe35c17@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-7-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-7-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list:
  Document precise event sampling for AMD IBS
Git-Commit-ID: 2055fdaf8703d3101b12e0d9b7cbceaeabe35c17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:30:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2055fdaf8703d3101b12e0d9b7cbceaeabe35c17
Gitweb:     http://git.kernel.org/tip/2055fdaf8703d3101b12e0d9b7cbceaeabe35c17
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:16 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:42:21 -0300

perf list: Document precise event sampling for AMD IBS

Updating man perf-list.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-7-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   42 ++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 12 deletions(-)

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
