Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919Ab0EEObr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:31:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136Ab0EEOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:30:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Nick Black <dank@qemfd.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf list: Add explanation about raw hardware event descriptors
Date: Wed,  5 May 2010 11:30:47 -0300
Message-Id: <1273069848-22934-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273069848-22934-1-git-send-email-acme@infradead.org>
References: <1273069848-22934-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using explanation given by Ingo Molnar in the oprofile mailing list.

Suggested-by: Nick Black <dank@qemfd.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Black <dank@qemfd.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   18 ++++++++++++++++++
 tools/perf/util/parse-events.c         |    2 +-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 8290b94..ad765e0 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -15,6 +15,24 @@ DESCRIPTION
 This command displays the symbolic event types which can be selected in the
 various perf commands with the -e option.
 
+RAW HARDWARE EVENT DESCRIPTOR
+-----------------------------
+Even when an event is not available in a symbolic form within perf right now,
+it can be encoded as <UMASK VALUE><EVENT NUM>, for instance, if the Intel docs
+describe an event as:
+
+  Event  Umask  Event Mask
+  Num.   Value  Mnemonic    Description                        Comment
+
+  A8H      01H  LSD.UOPS    Counts the number of micro-ops     Use cmask=1 and
+                            delivered by loop stream detector  invert to count
+                                                               cycles
+
+raw encoding of 0x1A8 can be used:
+
+ perf stat -e r1a8 -a sleep 1
+ perf record -e r1a8 ...
+
 OPTIONS
 -------
 None
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 600d327..bc8b7e6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -936,7 +936,7 @@ void print_events(void)
 
 	printf("\n");
 	printf("  %-42s [%s]\n",
-		"rNNN", event_type_descriptors[PERF_TYPE_RAW]);
+		"rNNN (NNN=<UMASK VALUE><EVENT NUM>)", event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
 	printf("  %-42s [%s]\n",
-- 
1.6.2.5

