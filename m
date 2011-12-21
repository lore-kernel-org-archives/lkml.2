Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1LUIrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:47:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LUIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:47:19 -0500
Date: Wed, 21 Dec 2011 00:46:54 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-cb8f4e9aa37c469ddd80dda51469f327606c0118@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-7-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-7-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Tidy up perf_event__preprocess_sample
Git-Commit-ID: cb8f4e9aa37c469ddd80dda51469f327606c0118
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:47:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb8f4e9aa37c469ddd80dda51469f327606c0118
Gitweb:     http://git.kernel.org/tip/cb8f4e9aa37c469ddd80dda51469f327606c0118
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:50:59 -0200

perf events: Tidy up perf_event__preprocess_sample

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
