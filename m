Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2K2Gnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:43:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44879 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2K2GjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:09 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-c6-50b70309f232
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/18] perf symbol: Introduce symbol_conf.event_group
Date: Thu, 29 Nov 2012 15:38:37 +0900
Message-Id: <1354171126-14387-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The event_group field is for enabling event group view on perf report
and other commands.  It requires collapsing hist entries since every
member in a group needs to be linked before final output resorting.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 4 ++++
 tools/perf/util/symbol.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 295f8d4feedf..a64b0bf77f32 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -15,6 +15,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "strlist.h"
+#include "sort.h"
 
 #include <elf.h>
 #include <limits.h>
@@ -1650,6 +1651,9 @@ int symbol__init(void)
 
 	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
 
+	if (symbol_conf.event_group)
+		sort__need_collapse = 1;
+
 	symbol_conf.initialized = true;
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index de68f98b236d..8bef1452675f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -96,7 +96,8 @@ struct symbol_conf {
 			initialized,
 			kptr_restrict,
 			annotate_asm_raw,
-			annotate_src;
+			annotate_src,
+			event_group;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

