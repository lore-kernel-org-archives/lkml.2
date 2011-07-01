Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1GAPTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:57387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1GAPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:19:49 -0400
Date: Fri, 1 Jul 2011 15:19:38 GMT
From: tip-bot for Eric B Munson <emunson@mgebm.net>
Message-ID: <tip-b7526f0ca6dc68f57ca467ce503151b1d476a3e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        emunson@mgebm.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, emunson@mgebm.net,
        mingo@elte.hu
In-Reply-To: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Add note to update_event_times comment about holding ctx->lock
Git-Commit-ID: b7526f0ca6dc68f57ca467ce503151b1d476a3e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:19:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7526f0ca6dc68f57ca467ce503151b1d476a3e4
Gitweb:     http://git.kernel.org/tip/b7526f0ca6dc68f57ca467ce503151b1d476a3e4
Author:     Eric B Munson <emunson@mgebm.net>
AuthorDate: Thu, 23 Jun 2011 16:34:37 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:33 +0200

events: Add note to update_event_times comment about holding ctx->lock

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1308861279-15216-1-git-send-email-emunson@mgebm.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e4aee51..2293e0b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -748,6 +748,7 @@ static u64 perf_event_time(struct perf_event *event)
 
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
+ * The caller of this function needs to hold the ctx->lock.
  */
 static void update_event_times(struct perf_event *event)
 {
