Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0JWU2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 16:28:37 -0400
Received: from canuck.infradead.org ([134.117.69.58]:45563 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab0JWU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 16:28:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf tools: Document event modifiers
Date: Sat, 23 Oct 2010 18:28:21 -0200
Message-Id: <1287865704-3880-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287865704-3880-1-git-send-email-acme@infradead.org>
References: <1287865704-3880-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>

Existing documentation doesn't discuss event modifiers, so add a description of
what's currently possible to the documentation of perf-list.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1287107460-12112-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.6.2.5

