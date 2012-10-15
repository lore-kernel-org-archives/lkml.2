Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2JODkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:40:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53649 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2JODj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:39:57 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-8a-507b858a7eda
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 2/2] perf tools: Remove warnings on JIT samples for srcline sort key
Date: Mon, 15 Oct 2012 12:39:43 +0900
Message-Id: <1350272383-7016-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1350272383-7016-1-git-send-email-namhyung@kernel.org>
References: <1350272383-7016-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When using the srcline sort key with perf report, I see many lines of
warning related to JIT samples like below:

  addr2line: '/tmp/perf-1397.map': No such file

Since it's not a ELF binary and doesn't provide such information, just
use the raw ip address.

Cc: David Ahern <dsahern@gmail.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Maybe you want fold this into patch #1 and I'm okay with it. :)

 tools/perf/util/sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index dd68f115d392..cfd1c0feb32d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -263,6 +263,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
+	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
+		goto out_ip;
+
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
-- 
1.7.11.4

