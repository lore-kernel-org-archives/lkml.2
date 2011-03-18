Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1CROhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:37:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab1CROhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:37:11 -0400
Date: Fri, 18 Mar 2011 14:36:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] trace, filters: Initialize the match variable in process_ops() properly
Message-ID: <tip-1ef1d1c2353967e2d61ecaddf76edfd058a778b4@git.kernel.org>
Git-Commit-ID: 1ef1d1c2353967e2d61ecaddf76edfd058a778b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Mar 2011 14:36:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ef1d1c2353967e2d61ecaddf76edfd058a778b4
Gitweb:     http://git.kernel.org/tip/1ef1d1c2353967e2d61ecaddf76edfd058a778b4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 18 Mar 2011 14:41:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Mar 2011 14:41:27 +0100

trace, filters: Initialize the match variable in process_ops() properly

Make sure the 'match' variable always has a value.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 3249b4f..8008ddc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -391,8 +391,8 @@ static int process_ops(struct filter_pred *preds,
 		       struct filter_pred *op, void *rec)
 {
 	struct filter_pred *pred;
+	int match = 0;
 	int type;
-	int match;
 	int i;
 
 	/*
