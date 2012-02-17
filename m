Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2BQJoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:44:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2BQJoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:44:06 -0500
Date: Fri, 17 Feb 2012 01:43:34 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d3665498955779e56453501a16f4ad084f798802@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
References: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: No build id option fails
Git-Commit-ID: d3665498955779e56453501a16f4ad084f798802
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:43:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3665498955779e56453501a16f4ad084f798802
Gitweb:     http://git.kernel.org/tip/d3665498955779e56453501a16f4ad084f798802
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 6 Feb 2012 15:27:52 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Feb 2012 12:28:10 -0200

perf record: No build id option fails

A recent refactoring of perf-record introduced the following:

perf record -a -B
Couldn't generating buildids. Use --no-buildid to profile anyway.
sleep: Terminated

I believe the triple negative was meant to be only a double negative.
:-) While I'm there, fixed the grammar on the error message.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1328567272-13190-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f8d9a54..d6d1c6c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -494,9 +494,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			return err;
 	}
 
-	if (!!rec->no_buildid
+	if (!rec->no_buildid
 	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
-		pr_err("Couldn't generating buildids. "
+		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		return -1;
 	}
