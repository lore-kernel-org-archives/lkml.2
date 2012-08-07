Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2HGRon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:43 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:47605
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab2HGRog convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z3e12hzc89bhzz1202hzz8275bhz2dh668h839h93fhd24he5bhf0ah)
X-WSS-ID: 0M8EBY6-02-01M-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: =?UTF-8?q?=5BPATCH=206/6=5D=20perf=2C=20tools=3A=20Document=20precise=20event=20sampling=20for=20AMD=20IBS?=
Date: Tue, 7 Aug 2012 19:43:16 +0200
Message-ID: <1344361396-7237-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating man perf-list.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.8.4


