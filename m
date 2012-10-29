Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab2J2PJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:09:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34794 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2J2PJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/14] perf record: Fix mmap error output condition
Date: Mon, 29 Oct 2012 13:09:12 -0200
Message-Id: <1351523353-27982-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The mmap_pages default value is not power of 2 (UINT_MAX).

Together with perf_evlist__mmap function returning error value different
from EPERM, we get misleading error message: "--mmap_pages/-m value must
be a power of two."

Fixing this by adding extra check for UINT_MAX value for this error
condition.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1350743599-4805-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 53c9892..5783c32 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -363,7 +363,8 @@ try_again:
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
 			       "(current value: %d)\n", opts->mmap_pages);
 			rc = -errno;
-		} else if (!is_power_of_2(opts->mmap_pages)) {
+		} else if (!is_power_of_2(opts->mmap_pages) &&
+			   (opts->mmap_pages != UINT_MAX)) {
 			pr_err("--mmap_pages/-m value must be a power of two.");
 			rc = -EINVAL;
 		} else {
-- 
1.7.9.2.358.g22243

