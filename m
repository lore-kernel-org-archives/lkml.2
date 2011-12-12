Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1LLPSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:18:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33919 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1LLPRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:17:34 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] perf events: Tidy up perf_event__preprocess_sample
Date: Tue, 13 Dec 2011 00:16:55 +0900
Message-Id: <1323703017-6060-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use local variable 'dso' to reduce typing a bit and rearrange
the if condition. Also NULL check of al->map in the condition
is not necessary.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/event.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 97c479bcb0dc..b7c7f39a8f6d 100644
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
1.7.6

