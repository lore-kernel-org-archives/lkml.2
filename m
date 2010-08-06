Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab0HFRGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:06:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:42441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761606Ab0HFRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:05:51 -0400
Date: Fri, 6 Aug 2010 17:05:20 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Fixup addr snprintf width on 32 bit arches
Message-ID: <tip-fb89941ea761f53201959cc217a2c73f6fe13855@git.kernel.org>
Git-Commit-ID: fb89941ea761f53201959cc217a2c73f6fe13855
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:05:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb89941ea761f53201959cc217a2c73f6fe13855
Gitweb:     http://git.kernel.org/tip/fb89941ea761f53201959cc217a2c73f6fe13855
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Aug 2010 19:17:22 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:01 -0300

perf hists: Fixup addr snprintf width on 32 bit arches

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
