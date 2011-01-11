Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1AKA22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:28:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1AKA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:28:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        a.p.zijlstra@chello.nl, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] perf stat: better error message for unsupported events
Date: Mon, 10 Jan 2011 22:28:08 -0200
Message-Id: <1294705692-9537-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294705692-9537-1-git-send-email-acme@infradead.org>
References: <1294705692-9537-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <daahern@cisco.com>

For unsupported events (e.g., H/W events when running in a VM)
perf stat currently fails with the error message:

      Error: open_counter returned with 2 (No such file or directory).
    /bin/dmesg may provide additional information.

      Fatal: Not all events could be opened.

dmesg is of no help and it is not clear as to why it fails to
open the counter. This patch changes the error message to

      Error: cache-misses event is not supported.
      Fatal: Not all events could be opened.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: a.p.zijlstra@chello.nl
LPU-Reference: <1294597272-17335-1-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2dfcb61..c385a63 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -316,6 +316,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
+			} else if (errno == ENOENT) {
+				error("%s event is not supported. ", event_name(counter));
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
-- 
1.6.2.5

