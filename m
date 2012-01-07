Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2AGRZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:25:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41981 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab2AGRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:25:44 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] perf top: Add error message for EMFILE
Date: Sun,  8 Jan 2012 02:25:27 +0900
Message-Id: <1325957132-10600-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user tries to open so many events, perf_event_open syscall
may fail with EMFILE. Provide advise for that case.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4f81eeb99875..ad18dd37e87d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -889,6 +889,10 @@ try_again:
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
1.7.6

