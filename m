Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1EXCw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:52:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:39346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1EXCwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:52:20 -0400
Date: Tue, 24 May 2011 02:51:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-0f61f3e4db71946292ef8d6d6df74b8fcf001646@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306200686-17317-1-git-send-email-fweisbec@gmail.com>
References: <1306200686-17317-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix sample type size calculation in 32 bits archs
Git-Commit-ID: 0f61f3e4db71946292ef8d6d6df74b8fcf001646
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 May 2011 02:51:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f61f3e4db71946292ef8d6d6df74b8fcf001646
Gitweb:     http://git.kernel.org/tip/0f61f3e4db71946292ef8d6d6df74b8fcf001646
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 24 May 2011 03:31:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 May 2011 04:33:24 +0200

perf tools: Fix sample type size calculation in 32 bits archs

The shift used here to count the number of bits set in
the mask doesn't work above the low part for archs that
are not 64 bits.

Fix the constant used for the shift.

This fixes a 32-bit perf top failure reported by Eric Dumazet:

	Can't parse sample, err = -14
	Can't parse sample, err = -14
	...

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com
Link: http://lkml.kernel.org/r/1306200686-17317-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 252b72a..6635fcd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
 	int i;
 
 	for (i = 0; i < 64; i++) {
-		if (mask & (1UL << i))
+		if (mask & (1ULL << i))
 			size++;
 	}
 
