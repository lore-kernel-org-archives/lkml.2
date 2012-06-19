Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2FSSBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:01:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:43382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2FSSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:01:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Samuel Liao <samuelliao@tencent.com>,
        Shan Wei <davidshan@tencent.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/20] perf annotate: Check null of sym pointer before using it
Date: Tue, 19 Jun 2012 14:50:21 -0300
Message-Id: <1340128221-17348-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Liao <samuelliao@tencent.com>

Sym may be NULL, and that will cause perf to crash.

Signed-off-by: Shan Wei <davidshan@tencent.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FCD95D3.90209@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 34b1c46..67a2703 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -814,7 +814,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 {
 	struct disasm_line *pos, *n;
 	struct annotation *notes;
-	const size_t size = symbol__size(sym);
+	size_t size;
 	struct map_symbol ms = {
 		.map = map,
 		.sym = sym,
@@ -834,6 +834,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (sym == NULL)
 		return -1;
 
+	size = symbol__size(sym);
+
 	if (map->dso->annotate_warned)
 		return -1;
 
-- 
1.7.1

