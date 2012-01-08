Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2AHPma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:42:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:59572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2AHPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf top: Add error message for EMFILE
Date: Sun,  8 Jan 2012 13:42:13 -0200
Message-Id: <1326037339-31125-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

When a user tries to open so many events, perf_event_open syscall may
fail with EMFILE. Provide advise for that case.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-3-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d89dec9..8f80df8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -888,6 +888,10 @@ try_again:
 				ui__warning("The %s event is not supported.\n",
 					    event_name(counter));
 				goto out_err;
+			} else if (err == EMFILE) {
+				ui__warning("Too many events are opened.\n"
+					    "Try again after reducing the number of events\n");
+				goto out_err;
 			}
 
 			ui__warning("The sys_perf_event_open() syscall "
-- 
1.7.8.GIT

