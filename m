Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2I1IjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:39:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:13515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab2I1IhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188636"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 6/8] perf header: Add is_perf_magic() func
Date: Fri, 28 Sep 2012 16:30:38 +0800
Message-Id: <1348821040-9724-7-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
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
 2 files changed, 11 insertions(+), 0 deletions(-)

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
index 99bdd3a..0af8c38 100644
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
1.7.1

