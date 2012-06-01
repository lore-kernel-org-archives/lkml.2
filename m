Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850Ab2FAWSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:18:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:59523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672Ab2FAWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/15] perf symbols: Check for valid dso before creating map
Date: Fri,  1 Jun 2012 19:16:36 -0300
Message-Id: <1338588999-32509-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

dso__new() can return NULL. Hence verify dso before creating a new map.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20120531114656.23691.54223.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9d04dcd..3e2e5ea 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2817,8 +2817,11 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
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
-- 
1.7.1

