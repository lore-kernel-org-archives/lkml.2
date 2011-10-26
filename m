Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1JZDja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 23:39:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40921 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1JZDj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 23:39:29 -0400
From: furat.afram@gmail.com
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Cc: Furat Afram <furat.afram@gmail.com>
Subject: [PATCH 1/1] perf probe:fix sigsegv in adding nonexistent event
Date: Tue, 25 Oct 2011 20:39:05 -0700
Message-Id: <1319600345-29311-1-git-send-email-furat.afram@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Furat Afram <furat.afram@gmail.com>

pref probe crashes when trying to add nonexistent event

Signed-off-by: Furat Afram <furat.afram@gmail.com>
---
 tools/perf/util/symbol.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 40eeaf0..ad0c79b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -636,14 +636,18 @@ static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
 static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			       symbol_filter_t filter)
 {
-	struct map_groups *kmaps = map__kmap(map)->kmaps;
-	struct machine *machine = kmaps->machine;
+	struct map_groups *kmaps;
+	struct machine *machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
 	int count = 0, moved = 0;	
 	struct rb_root *root = &dso->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
+	kmaps = map__kmap(map)->kmaps;
+	if (kmaps == NULL)
+		return -1;
+	machine = kmaps->machine;
 
 	while (next) {
 		char *module;
-- 
1.7.6.4

