Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2IJQvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab2IJQu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:50:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] perf dso: Make dsos__find function globally available
Date: Mon, 10 Sep 2012 18:50:18 +0200
Message-Id: <1347295819-23177-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing dsos__find function from static to be globally available.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c | 2 +-
 tools/perf/util/symbol.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 753699a..b401497 100644
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
-- 
1.7.11.4

