Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1HKUzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:55:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54734 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1HKUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:55:46 -0400
Date: Fri, 12 Aug 2011 00:55:37 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf: fix temporary file ownership check
Message-ID: <20110811205537.GA22864@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A file in /tmp/ might be a symlink, so lstat() should be used
instead of stat().

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a8b5371..5db39f6 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1506,7 +1506,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
 		struct stat st;
 
-		if (stat(dso->name, &st) < 0)
+		if (lstat(dso->name, &st) < 0)
 			return -1;
 
 		if (st.st_uid && (st.st_uid != geteuid())) {
-- 
1.7.0.4

