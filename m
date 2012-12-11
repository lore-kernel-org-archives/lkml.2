Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2LKWsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43841 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2LKWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/37] perf hists: Link hist entry pairs to leader
Date: Tue, 11 Dec 2012 19:47:58 -0300
Message-Id: <1355266103-17238-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current hists__match/link() link a leader to its pair, so if multiple
pairs were linked, the leader will lose pointer to previous pairs since
it was overwritten.  Fix it by making leader the list head.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1354171126-14387-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d2bc05c..82df1b2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -785,7 +785,7 @@ void hists__match(struct hists *leader, struct hists *other)
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
-			hist_entry__add_pair(pos, pair);
+			hist_entry__add_pair(pair, pos);
 	}
 }
 
@@ -806,7 +806,7 @@ int hists__link(struct hists *leader, struct hists *other)
 			pair = hists__add_dummy_entry(leader, pos);
 			if (pair == NULL)
 				return -1;
-			hist_entry__add_pair(pair, pos);
+			hist_entry__add_pair(pos, pair);
 		}
 	}
 
-- 
1.7.9.2.358.g22243

