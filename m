Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab2IGGHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:07:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992Ab2IGGHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:07:37 -0400
Date: Thu, 6 Sep 2012 23:07:21 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-618a3f1d30ea0ee2ff3a88661b8d6a4035123211@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346821373-31621-3-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header:
  Set tracepoint event name only if not set
Git-Commit-ID: 618a3f1d30ea0ee2ff3a88661b8d6a4035123211
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:07:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  618a3f1d30ea0ee2ff3a88661b8d6a4035123211
Gitweb:     http://git.kernel.org/tip/618a3f1d30ea0ee2ff3a88661b8d6a4035123211
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 5 Sep 2012 14:02:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:46:34 -0300

perf header: Set tracepoint event name only if not set

The event name can be set already by processing a event_desc data.

So check it before setting to prevent possible leak.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346821373-31621-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a124b93..05c9310 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2314,7 +2314,7 @@ static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT && !pos->name &&
 		    perf_evsel__set_tracepoint_name(pos, pevent))
 			return -1;
 	}
