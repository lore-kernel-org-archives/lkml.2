Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2HUQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:25:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HUQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:25:57 -0400
Date: Tue, 21 Aug 2012 09:25:37 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-ca1b145761e9355f90bfae1f42c9d9194702066b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-3-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Report number of pmu type of unknown events
Git-Commit-ID: ca1b145761e9355f90bfae1f42c9d9194702066b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:25:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca1b145761e9355f90bfae1f42c9d9194702066b
Gitweb:     http://git.kernel.org/tip/ca1b145761e9355f90bfae1f42c9d9194702066b
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:18 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 13:11:29 -0300

perf tools: Report number of pmu type of unknown events

If detection fails and an event name is unknown, report the type number.
Example perf header output:

 # Samples: 10K of event 'unknown attr type: 7'

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-3-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6c7dcc1..7ff3c8f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -319,7 +319,8 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 		break;
 
 	default:
-		scnprintf(bf, sizeof(bf), "%s", "unknown attr type");
+		scnprintf(bf, sizeof(bf), "unknown attr type: %d",
+			  evsel->attr.type);
 		break;
 	}
 
