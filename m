Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2IXPbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:31:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:56118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab2IXPal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413243"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 7/9] perf header: Add check_perf_magic() func
Date: Mon, 24 Sep 2012 23:24:09 +0800
Message-Id: <1348500251-9937-8-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this func, other modules can basically check whether a file
is a legal perf data file by checking its first 8 bytes aginst
all possible perf magic nunbers.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/util/header.c |   11 +++++++++++
 tools/perf/util/header.h |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ad72b28..555cb68 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2174,6 +2174,17 @@ static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
 	return -1;
 }
 
+/* Return 0 if matched */
+int check_perf_magic(u64 magic)
+{
+	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
+		|| magic == __perf_magic2
+		|| magic == __perf_magic2_sw)
+		return 0;
+
+	return -1;
+}
+
 static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 			      bool is_pipe, struct perf_header *ph)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 58de08b..af1a51c 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -131,6 +131,7 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
 int perf_event__process_build_id(struct perf_tool *tool,
 				 union perf_event *event,
 				 struct perf_session *session);
+int check_perf_magic(u64 magic);
 
 /*
  * arch specific callback
-- 
1.7.1

