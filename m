Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0JXJni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:56007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0JXJng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:43:36 -0400
Date: Sun, 24 Oct 2010 09:42:58 GMT
From: tip-bot for Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        sonnyrao@linux.vnet.ibm.com, robert.richter@amd.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        sonnyrao@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1287107460-12112-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
References: <1287107460-12112-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Document event modifiers
Message-ID: <tip-ffec516976f64b4e3e59ba1bb8a5020008cc678a@git.kernel.org>
Git-Commit-ID: ffec516976f64b4e3e59ba1bb8a5020008cc678a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Oct 2010 09:43:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffec516976f64b4e3e59ba1bb8a5020008cc678a
Gitweb:     http://git.kernel.org/tip/ffec516976f64b4e3e59ba1bb8a5020008cc678a
Author:     Sonny Rao <sonnyrao@linux.vnet.ibm.com>
AuthorDate: Thu, 14 Oct 2010 20:51:00 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 23 Oct 2010 15:31:20 -0200

perf tools: Document event modifiers

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
