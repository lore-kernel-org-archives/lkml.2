Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0EQVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:09:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:59209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab0EQVJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:09:55 -0400
Date: Mon, 17 May 2010 21:09:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: symbol inconsistency message should be done only at verbose=1
Message-ID: <tip-2f51903bc3139e25ec908f8944a0001c7b868e90@git.kernel.org>
Git-Commit-ID: 2f51903bc3139e25ec908f8944a0001c7b868e90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 21:09:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f51903bc3139e25ec908f8944a0001c7b868e90
Gitweb:     http://git.kernel.org/tip/2f51903bc3139e25ec908f8944a0001c7b868e90
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 17 May 2010 17:57:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 May 2010 17:57:59 -0300

perf symbols: symbol inconsistency message should be done only at verbose=1

That happened for an old perf.data file that had no fake MMAP events for
the kernel modules, but even then it should warn once for each module,
not one time for every symbol in every module not found.

Reported-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ecccc8d..a06131f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -525,7 +525,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 				curr_map = map_groups__find_by_name(kmaps,
 							map->type, module);
 				if (curr_map == NULL) {
-					pr_err("%s/proc/{kallsyms,modules} "
+					pr_debug("%s/proc/{kallsyms,modules} "
 					         "inconsistency while looking "
 						 "for \"%s\" module!\n",
 						 machine->root_dir, module);
