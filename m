Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2IEFKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47884 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2IEFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:22 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-44-5046debcb367
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] perf header: Swap pmu mapping numbers if needed
Date: Wed,  5 Sep 2012 14:02:49 +0900
Message-Id: <1346821373-31621-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Like others, the numbers can be saved in a different endian format
than a host machine.  Swap them if needed.

Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 05c9310c3da1..43425b75f0c9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1440,6 +1440,9 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	if (ret != sizeof(pmu_num))
 		goto error;
 
+	if (ph->needs_swap)
+		pmu_num = bswap_32(pmu_num);
+
 	if (!pmu_num) {
 		fprintf(fp, "# pmu mappings: not available\n");
 		return;
@@ -1448,6 +1451,9 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	while (pmu_num) {
 		if (read(fd, &type, sizeof(type)) != sizeof(type))
 			break;
+		if (ph->needs_swap)
+			type = bswap_32(type);
+
 		name = do_read_string(fd, ph);
 		if (!name)
 			break;
-- 
1.7.11.4

