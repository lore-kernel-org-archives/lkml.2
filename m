Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1LTTT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:19:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:33890 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1LTTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf events: Tidy up perf_event__preprocess_sample
Date: Tue, 20 Dec 2011 17:18:10 -0200
Message-Id: <1324408691-28296-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Use local variable 'dso' to reduce typing a bit and rearrange the if
condition. Also NULL check of al->map in the condition is not necessary.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-7-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 97c479b..b7c7f39 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -814,13 +814,14 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	al->cpu = sample->cpu;
 
 	if (al->map) {
+		struct dso *dso = al->map->dso;
+
 		if (symbol_conf.dso_list &&
-		    (!al->map || !al->map->dso ||
-		     !(strlist__has_entry(symbol_conf.dso_list,
-					  al->map->dso->short_name) ||
-		       (al->map->dso->short_name != al->map->dso->long_name &&
-			strlist__has_entry(symbol_conf.dso_list,
-					   al->map->dso->long_name)))))
+		    (!dso || !(strlist__has_entry(symbol_conf.dso_list,
+						  dso->short_name) ||
+			       (dso->short_name != dso->long_name &&
+				strlist__has_entry(symbol_conf.dso_list,
+						   dso->long_name)))))
 			goto out_filtered;
 
 		al->sym = map__find_symbol(al->map, al->addr, filter);
-- 
1.7.8.rc0.35.gee6df

