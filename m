Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0JODNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:13:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59199 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0JODN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:13:26 -0400
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf, document event modifiers
Date: Thu, 14 Oct 2010 20:51:00 -0500
Message-Id: <1287107460-12112-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvm4.vnet.ibm.com (XAGENTU at VMSDVM4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing documentation doesn't discuss event modifiers,
so add a description of what's currently possible to
the documentation of perf-list.

Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-list.txt |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 43e3dd2..399751b 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -15,6 +15,23 @@ DESCRIPTION
 This command displays the symbolic event types which can be selected in the
 various perf commands with the -e option.

+EVENT MODIFIERS
+---------------
+
+Events can optionally have a modifer by appending a colon and one or
+more modifiers.  Modifiers allow the user to restrict when events are
+counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
+
+The 'p' modifier can be used for specifying how precise the instruction
+address should be. The 'p' modifier is currently only implemented for
+Intel PEBS and can be specified multiple times:
+  0 - SAMPLE_IP can have arbitrary skid
+  1 - SAMPLE_IP must have constant skid
+  2 - SAMPLE_IP requested to have 0 skid
+  3 - SAMPLE_IP must have 0 skid
+
+The PEBS implementation now supports up to 2.
+
 RAW HARDWARE EVENT DESCRIPTOR
 -----------------------------
 Even when an event is not available in a symbolic form within perf right now,
-- 
1.5.6.5

