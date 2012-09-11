Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab2IKX4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:56:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:42276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2IKXxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] perf symbols: Make dsos__find function globally available
Date: Tue, 11 Sep 2012 20:53:03 -0300
Message-Id: <1347407590-30960-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
 2 files changed, 2 insertions(+), 1 deletion(-)

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
-- 
1.7.9.2.358.g22243

