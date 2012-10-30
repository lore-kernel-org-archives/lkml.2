Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2J3MLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:11:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2J3MLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:11:20 -0400
Date: Tue, 30 Oct 2012 05:10:47 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-e84ba4e26833991d1c1c15a592b1474ee2b6dfdb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-7-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-7-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Add is_perf_magic() func
Git-Commit-ID: e84ba4e26833991d1c1c15a592b1474ee2b6dfdb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:10:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e84ba4e26833991d1c1c15a592b1474ee2b6dfdb
Gitweb:     http://git.kernel.org/tip/e84ba4e26833991d1c1c15a592b1474ee2b6dfdb
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:07 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:56:59 -0200

perf header: Add is_perf_magic() func

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
 2 files changed, 11 insertions(+), 0 deletions(-)

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
