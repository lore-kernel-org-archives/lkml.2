Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1L2U6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:58:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1L2U6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:58:16 -0500
Date: Thu, 29 Dec 2011 12:57:44 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-lfckuwbl8m1ykb7t9ydsxe4r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix feature-bits rework fallout,
  remove unused variable
Git-Commit-ID: f2328062726d36e562f1458d6346b77aa048acad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:57:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2328062726d36e562f1458d6346b77aa048acad
Gitweb:     http://git.kernel.org/tip/f2328062726d36e562f1458d6346b77aa048acad
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 29 Dec 2011 21:26:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Dec 2011 21:26:17 +0100

perf tools: Fix feature-bits rework fallout, remove unused variable

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/n/tip-lfckuwbl8m1ykb7t9ydsxe4r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e509a9d..3e7e0b0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1415,15 +1415,12 @@ static int perf_header__adds_write(struct perf_header *header,
 				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
-	struct perf_session *session;
 	struct perf_file_section *feat_sec, *p;
 	int sec_size;
 	u64 sec_start;
 	int feat;
 	int err;
 
-	session = container_of(header, struct perf_session, header);
-
 	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
