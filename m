Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2I0EYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:24:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:24:47 -0400
Date: Wed, 26 Sep 2012 21:24:14 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-1863fbbb781b1129da0cfdad46ef875370a34117@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120920161945.GA7064@quad>
References: <20120920161945.GA7064@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Print event causing perf_event_open()
  to fail
Git-Commit-ID: 1863fbbb781b1129da0cfdad46ef875370a34117
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 21:24:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1863fbbb781b1129da0cfdad46ef875370a34117
Gitweb:     http://git.kernel.org/tip/1863fbbb781b1129da0cfdad46ef875370a34117
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 20 Sep 2012 18:19:45 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 20 Sep 2012 14:44:17 -0300

perf record: Print event causing perf_event_open() to fail

Got tired of not getting the event that caused the perf_event_open()
syscall to fail. So I fixed the error message. This is very useful when
monitoring lots of events in a single run.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120920161945.GA7064@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c643ed6..2cb7434 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -297,8 +297,10 @@ try_again:
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
