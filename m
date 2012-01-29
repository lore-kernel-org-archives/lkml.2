Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2A2I4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:56:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59349 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2A2I4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:56:05 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] perf record: Add error message for EMFILE
Date: Sun, 29 Jan 2012 17:55:53 +0900
Message-Id: <1327827356-8786-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user tries to open so many events, perf_event_oen syscall
may fail with EMFILE. Provide an advice for that case.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 32870eef952f..5d3b6794d93b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -249,6 +249,10 @@ try_again:
 				ui__warning("The %s event is not supported.\n",
 					    event_name(pos));
 				exit(EXIT_FAILURE);
+			} else if (err == EMFILE) {
+				ui__warning("Too many events are opened.\n"
+					    "Try again after reducing the number of events.\n");
+				exit(EXIT_FAILURE);
 			}
 
 			printf("\n");
-- 
1.7.8.2

