Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LTTPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2LTTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: remove redundant checks from _sort__sym_cmp
Date: Thu, 20 Dec 2012 14:11:20 -0500
Message-Id: <1356030701-16284-12-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already check that sym_l and sum_r are non-NULLs, no need to
do it twice.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/util/sort.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..dbaded9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -143,10 +143,8 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 	if (sym_l == sym_r)
 		return 0;
 
-	if (sym_l)
-		ip_l = sym_l->start;
-	if (sym_r)
-		ip_r = sym_r->start;
+	ip_l = sym_l->start;
+	ip_r = sym_r->start;
 
 	return (int64_t)(ip_r - ip_l);
 }
-- 
1.8.0

