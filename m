Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab2J3NCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:02:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2J3NCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:02:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf header: Fix numa topology printing
Date: Tue, 30 Oct 2012 11:02:38 -0200
Message-Id: <1351602159-10340-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351602159-10340-1-git-send-email-acme@infradead.org>
References: <1351602159-10340-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
processed session env when printing") regresses the header output.  It
was because of a missed string pointer calculation in the loop.

Reported-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1350999890-6920-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..566b84c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1378,6 +1378,8 @@ static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
 
 		str = tmp + 1;
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+
+		str += strlen(str) + 1;
 	}
 	return;
 error:
-- 
1.7.9.2.358.g22243

