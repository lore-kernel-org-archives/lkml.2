Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640Ab2FVIOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:14:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59941 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761609Ab2FVIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:14:27 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-e0-4fe4295fdda4
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] tools lib traceevent: Teach [ce]tags about libtraceeevent error codes
Date: Fri, 22 Jun 2012 17:10:14 +0900
Message-Id: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we use a macro trick to sync each error codes with its
description string, teach [ce]tags to process them properly.

This patch modifies the libtraceevent's Makefile not a
kernel one.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-3101nsbg52glxdqih291qj74@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56daa768b9e3..15f6eb8f4935 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -284,11 +284,13 @@ TRACEEVENT-CFLAGS: force
 
 tags:	force
 	$(RM) tags
-	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px
+	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
 
 TAGS:	force
 	$(RM) TAGS
-	find . -name '*.[ch]' | xargs etags
+	find . -name '*.[ch]' | xargs etags \
+	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
 
 define do_install
 	$(print_install)				\
-- 
1.7.10.2

