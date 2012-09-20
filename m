Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2ITQTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:19:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36099 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2ITQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:19:52 -0400
Date: Thu, 20 Sep 2012 18:19:45 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf record: print event causing perf_event_open() to fail
Message-ID: <20120920161945.GA7064@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got tired of not getting the event that caused the perf_event_open()
syscall to fail. So I fixed the error message. This is very useful
when monitoring lots of events in a single run. 

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c643ed6..2cb7434 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -297,8 +297,10 @@ static int perf_record__open(struct perf_record *rec)
 			}
 
 			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
-			      err, strerror(err));
+			error("sys_perf_event_open() syscall returned with %d "
+			      "(%s) for event %s. /bin/dmesg may provide "
+			      "additional information.\n",
+			      err, strerror(err), perf_evsel__name(pos));
 
 #if defined(__i386__) || defined(__x86_64__)
 			if (attr->type == PERF_TYPE_HARDWARE &&
