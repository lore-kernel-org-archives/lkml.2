Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2HGRor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:47 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:10432
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642Ab2HGRog convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z3e12hzc89bhzz1202hzz8275bhz2dh668h839h93fhd24he5bhf0ah)
X-WSS-ID: 0M8EBY5-01-CEQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: =?UTF-8?q?=5BPATCH=205/6=5D=20perf=2C=20tools=3A=20Update=20documentation=20about=20raw=20event=20setup?=
Date: Tue, 7 Aug 2012 19:43:15 +0200
Message-ID: <1344361396-7237-6-git-send-email-robert.richter@amd.com>
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

It was missing that only certain bit fields are passed to the config
value which confused users. Updating it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Documentation/perf-list.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index ddc2252..232be51 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -15,6 +15,7 @@ DESCRIPTION
 This command displays the symbolic event types which can be selected in the
 various perf commands with the -e option.
 
+[[EVENT_MODIFIERS]]
 EVENT MODIFIERS
 ---------------
 
@@ -44,6 +45,11 @@ layout of IA32_PERFEVTSELx MSRs (see [Intel® 64 and IA-32 Architectures Softwar
 of IA32_PERFEVTSELx MSRs) or AMD's PerfEvtSeln (see [AMD64 Architecture Programmer’s Manual Volume 2: System Programming], Page 344,
 Figure 13-7 Performance Event-Select Register (PerfEvtSeln)).
 
+Note: Only the following bit fields can be set in x86 counter
+registers: event, umask, edge, inv, cmask. Esp. guest/host only and
+OS/user mode flags must be setup using <<EVENT_MODIFIERS, EVENT
+MODIFIERS>>.
+
 Example:
 
 If the Intel docs for a QM720 Core i7 describe an event as:
-- 
1.7.8.4


