Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab2IGGGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:06:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2IGGGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:06:50 -0400
Date: Thu, 6 Sep 2012 23:06:24 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-74ba9e11f02a4ce0c7708dc77d1756b93065e440@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346821373-31621-2-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Use evlist->
 nr_entries on write_event_desc()
Git-Commit-ID: 74ba9e11f02a4ce0c7708dc77d1756b93065e440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:06:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74ba9e11f02a4ce0c7708dc77d1756b93065e440
Gitweb:     http://git.kernel.org/tip/74ba9e11f02a4ce0c7708dc77d1756b93065e440
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 5 Sep 2012 14:02:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:46:03 -0300

perf header: Use evlist->nr_entries on write_event_desc()

Number of events (evsels) in a evlist is kept on nr_entries field
so that we don't need to recalculate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346821373-31621-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9696e64..a124b93 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -610,11 +610,10 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	u32 nre = 0, nri, sz;
+	u32 nre, nri, sz;
 	int ret;
 
-	list_for_each_entry(evsel, &evlist->entries, node)
-		nre++;
+	nre = evlist->nr_entries;
 
 	/*
 	 * write number of events
