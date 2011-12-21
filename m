Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1LULsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:48:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1LULse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:48:34 -0500
Date: Wed, 21 Dec 2011 03:48:10 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-1ixr3olci40w8rgv2evv2ldh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf: Fix mmap_page::offset computation
Git-Commit-ID: 365a4038486b57bb2bd516706a80f82f250f5306
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:48:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  365a4038486b57bb2bd516706a80f82f250f5306
Gitweb:     http://git.kernel.org/tip/365a4038486b57bb2bd516706a80f82f250f5306
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Nov 2011 20:58:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:09 +0100

perf: Fix mmap_page::offset computation

There's multiple reason the counter might be unavailable, change the
condition to !->index since perf_event_index() should return 0 for all
those cases.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-1ixr3olci40w8rgv2evv2ldh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3894309..05affc3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3268,7 +3268,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	barrier();
 	userpg->index = perf_event_index(event);
 	userpg->offset = perf_event_count(event);
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
+	if (userpg->index)
 		userpg->offset -= local64_read(&event->hw.prev_count);
 
 	userpg->time_enabled = enabled +
