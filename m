Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2AHPz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:55:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2AHPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:55:36 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf stat: Add error message for EMFILE
Date: Mon,  9 Jan 2012 00:55:25 +0900
Message-Id: <1326038125-2929-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1326038125-2929-1-git-send-email-namhyung@gmail.com>
References: <1326038125-2929-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user tries to open so many events, perf_event_oen syscall
may fail with EMFILE. Provide an advice for that case.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-stat.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f5d2a63eba66..3e6c8dd8417f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -477,6 +477,9 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
+			} else if (errno == EMFILE) {
+				error("Too many events are opened.\n"
+				      "\t Try again after reducing the number of events.\n");
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
-- 
1.7.8.2

