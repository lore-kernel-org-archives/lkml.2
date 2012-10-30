Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab2J2D5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:57:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:42679 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab2J2D5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544447"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 6/8] perf header: Add is_perf_magic() func
Date: Tue, 30 Oct 2012 11:56:07 +0800
Message-Id: <1351569369-26732-7-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this function, other modules can basically check whether a
file is a legal perf data file by checking its first 8 bytes
against all possible perf magic numbers.

Change the function name from check_perf_magic to more meaningful
is_perf_magic as suggested by acme.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/util/header.c |   10 ++++++++++
 tools/perf/util/header.h |    1 +
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..87e679e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2340,6 +2340,16 @@ static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
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
1.7.9.5

