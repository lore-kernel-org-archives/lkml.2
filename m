Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2J2PLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:11:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2J2PJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/14] perf header: Add is_perf_magic() func
Date: Mon, 29 Oct 2012 13:09:11 -0200
Message-Id: <1351523353-27982-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

With this function, other modules can basically check whether a file is
a legal perf data file by checking its first 8 bytes against all
possible perf magic numbers.

Change the function name from check_perf_magic to more meaningful
is_perf_magic as suggested by acme.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-7-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   10 ++++++++++
 tools/perf/util/header.h |    1 +
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 514ed1b..195a47a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2341,6 +2341,16 @@ static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
 	return -1;
 }
 
+bool is_perf_magic(u64 magic)
+{
+	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
+		|| magic == __perf_magic2
+		|| magic == __perf_magic2_sw)
+		return true;
+
+	return false;
+}
+
 static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 			      bool is_pipe, struct perf_header *ph)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 879d215..5f1cd68 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -154,6 +154,7 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
 int perf_event__process_build_id(struct perf_tool *tool,
 				 union perf_event *event,
 				 struct perf_session *session);
+bool is_perf_magic(u64 magic);
 
 /*
  * arch specific callback
-- 
1.7.9.2.358.g22243

