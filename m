Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202Ab0HFBqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:46:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760863Ab0HFBqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:46:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf hists: Fixup addr snprintf width on 32 bit arches
Date: Thu,  5 Aug 2010 22:46:12 -0300
Message-Id: <1281059177-18747-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281059177-18747-1-git-send-email-acme@infradead.org>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By using BITS_PER_LONG/4 as the width specifier.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1c61a4f..b62a553 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -196,7 +196,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 
 	if (verbose) {
 		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
-		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
+		ret += repsep_snprintf(bf, size, "%*Lx %c ",
+				       BITS_PER_LONG / 4, self->ip, o);
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
@@ -204,7 +205,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 		ret += repsep_snprintf(bf + ret, size - ret, "%s",
 				       self->ms.sym->name);
 	else
-		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
+		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
+				       BITS_PER_LONG / 4, self->ip);
 
 	return ret;
 }
-- 
1.6.2.5

