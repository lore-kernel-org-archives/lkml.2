Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2EaLtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:49:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52794 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2EaLtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:49:15 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Thu, 31 May 2012 17:16:56 +0530
Message-Id: <20120531114656.23691.54223.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 3/3] perf: Check for valid dso before creating map
x-cbid: 12053111-4790-0000-0000-00000305D392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

dso__new() can return NULL. Hence verify dso before creating
a new map.

Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2ba885..0ef529e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2786,8 +2786,11 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
 struct map *dso__new_map(const char *name)
 {
+	struct map *map = NULL;
 	struct dso *dso = dso__new(name);
-	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	if (dso)
+		map = map__new2(0, dso, MAP__FUNCTION);
 
 	return map;
 }


