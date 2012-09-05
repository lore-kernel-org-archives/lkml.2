Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab2IEXJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759875Ab2IEXJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/17] perf header: Swap pmu mapping numbers if needed
Date: Wed,  5 Sep 2012 20:08:55 -0300
Message-Id: <1346886537-11621-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Like others, the numbers can be saved in a different endian format than
a host machine.  Swap them if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1346821373-31621-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 05c9310..43425b7 100644
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
1.7.1

