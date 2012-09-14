Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2INGAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:00:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2INGAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:00:45 -0400
Date: Thu, 13 Sep 2012 23:00:11 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-1c4be9ff5933e5c0f033ea98169cd89e22c90900@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1347295819-23177-4-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Make dsos__find function globally available
Git-Commit-ID: 1c4be9ff5933e5c0f033ea98169cd89e22c90900
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:00:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c4be9ff5933e5c0f033ea98169cd89e22c90900
Gitweb:     http://git.kernel.org/tip/1c4be9ff5933e5c0f033ea98169cd89e22c90900
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 10 Sep 2012 18:50:18 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 12:05:16 -0300

perf symbols: Make dsos__find function globally available

Changing dsos__find function from static to be globally available.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 tools/perf/util/symbol.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ba85d4f..bbb24e9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1596,7 +1596,7 @@ void dsos__add(struct list_head *head, struct dso *dso)
 	list_add_tail(&dso->node, head);
 }
 
-static struct dso *dsos__find(struct list_head *head, const char *name)
+struct dso *dsos__find(struct list_head *head, const char *name)
 {
 	struct dso *pos;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 41a15da..dde8a26 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -294,6 +294,7 @@ static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 void dso__sort_by_name(struct dso *dso, enum map_type type);
 
 void dsos__add(struct list_head *head, struct dso *dso);
+struct dso *dsos__find(struct list_head *head, const char *name);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
