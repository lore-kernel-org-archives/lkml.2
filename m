Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2KNGf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:35:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2KNGfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:35:25 -0500
Date: Tue, 13 Nov 2012 22:35:08 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-ffadcf090d468e9c4938b718649f38dd10cfdb02@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        ak@linux.intel.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1351643663-23828-18-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-18-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Handle XBEGIN like a jump
Git-Commit-ID: ffadcf090d468e9c4938b718649f38dd10cfdb02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:35:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffadcf090d468e9c4938b718649f38dd10cfdb02
Gitweb:     http://git.kernel.org/tip/ffadcf090d468e9c4938b718649f38dd10cfdb02
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 30 Oct 2012 17:34:08 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:18:26 -0200

perf annotate: Handle XBEGIN like a jump

So that the browser still shows the abort label.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1351643663-23828-18-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7a34dd1..b14d4df 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -401,6 +401,8 @@ static struct ins instructions[] = {
 	{ .name = "testb", .ops  = &mov_ops, },
 	{ .name = "testl", .ops  = &mov_ops, },
 	{ .name = "xadd",  .ops  = &mov_ops, },
+	{ .name = "xbeginl", .ops  = &jump_ops, },
+	{ .name = "xbeginq", .ops  = &jump_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
