Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab2EWP1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:27:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993Ab2EWP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:27:48 -0400
Date: Wed, 23 May 2012 08:27:20 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-6a11f92ef449bfb87f93e7cc14cb2a717afc7aa3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1337151548-2396-4-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add union u64_swap type for swapping u64 data
Git-Commit-ID: 6a11f92ef449bfb87f93e7cc14cb2a717afc7aa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:27:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a11f92ef449bfb87f93e7cc14cb2a717afc7aa3
Gitweb:     http://git.kernel.org/tip/6a11f92ef449bfb87f93e7cc14cb2a717afc7aa3
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 16 May 2012 08:59:04 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:50:25 -0300

perf tools: Add union u64_swap type for swapping u64 data

The following union:
  union {
        u64 val64;
        u32 val32[2];
  } u;

is used on more than one place in perf code and will be used more in
upcomming patches.

Adding union u64_swap to have it defined globaly so we dont need to
redefine it all the time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337151548-2396-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   10 ++--------
 tools/perf/util/types.h |    5 +++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9abd8ac..57e4ce5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -462,10 +462,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
@@ -608,10 +605,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	array = event->sample.array;
 
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index 5f3689a..c51fa6b 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -16,4 +16,9 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #endif /* __PERF_TYPES_H */
