Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2L0JMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:31 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59226 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2L0JM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:29 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-12-50dc10fb626f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/10] perf sort: Get rid of unnecessary __maybe_unused
Date: Thu, 27 Dec 2012 18:11:39 +0900
Message-Id: <1356599507-14226-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some functions have set __maybe_unused on its arguments that are used
actually.  Remove them.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index ce5d40456c07..3c2836eeafb5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -197,7 +197,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
-				     unsigned int width __maybe_unused)
+				     unsigned int width)
 {
 	size_t ret = 0;
 
@@ -224,8 +224,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 }
 
 static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size,
-				    unsigned int width __maybe_unused)
+				    size_t size, unsigned int width)
 {
 	return _hist_entry__sym_snprintf(self->ms.map, self->ms.sym, self->ip,
 					 self->level, bf, size, width);
@@ -398,8 +397,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
-					size_t size,
-					unsigned int width __maybe_unused)
+					 size_t size, unsigned int width)
 {
 	struct addr_map_symbol *from = &self->branch_info->from;
 	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
@@ -408,8 +406,7 @@ static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
 }
 
 static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
-				       size_t size,
-				       unsigned int width __maybe_unused)
+				       size_t size, unsigned int width)
 {
 	struct addr_map_symbol *to = &self->branch_info->to;
 	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
-- 
1.7.11.7

