Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2DZMTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:19:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2DZMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:19:07 -0400
Date: Thu, 26 Apr 2012 05:18:54 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-33b07b8be7f0e1e8e4184e3473d71f174e4b0641@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333643084-26776-4-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Use static variant of perf_event_overflow in core.c
Git-Commit-ID: 33b07b8be7f0e1e8e4184e3473d71f174e4b0641
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 05:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33b07b8be7f0e1e8e4184e3473d71f174e4b0641
Gitweb:     http://git.kernel.org/tip/33b07b8be7f0e1e8e4184e3473d71f174e4b0641
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:24:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 13:52:52 +0200

perf: Use static variant of perf_event_overflow in core.c

No need to have an additional function layer.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333643084-26776-4-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..9789a56 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5350,7 +5350,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	if (regs && !perf_exclude_event(event, regs)) {
 		if (!(event->attr.exclude_idle && is_idle_task(current)))
-			if (perf_event_overflow(event, &data, regs))
+			if (__perf_event_overflow(event, 1, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
 
