Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1L2Uwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:52:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39676 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1L2Uwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:52:44 -0500
Date: Thu, 29 Dec 2011 12:52:20 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-f7a8a1336416883dc0ccd96c17c604e34de61c25@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323248577-11268-2-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Continue processing header on unknown features
Git-Commit-ID: f7a8a1336416883dc0ccd96c17c604e34de61c25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:52:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7a8a1336416883dc0ccd96c17c604e34de61c25
Gitweb:     http://git.kernel.org/tip/f7a8a1336416883dc0ccd96c17c604e34de61c25
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 7 Dec 2011 10:02:51 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:57:09 -0200

perf tools: Continue processing header on unknown features

A feature may be unknown if perf.data is created and parsed on different
perf tool versions. This should not stop the header to be processed,
instead continue processing it.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-2-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c48be8..428a4a2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1109,7 +1109,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 	}
 	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
 		pr_warning("unknown feature %d\n", feat);
-		return -1;
+		return 0;
 	}
 	if (!feat_ops[feat].print)
 		return 0;
