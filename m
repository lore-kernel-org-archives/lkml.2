Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2JWNqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:46:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab2JWNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:45:59 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf header: Fix numa topology printing
Date: Tue, 23 Oct 2012 22:44:49 +0900
Message-Id: <1350999890-6920-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20121023072702.GB2772@turtle.usersys.redhat.com>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
processed session env when printing") regresses the header output.
It was because of a missed string pointer calculation in the loop.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad237dea5..566b84c695c8 100644
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
1.7.9.2

