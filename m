Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0KZPEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:04:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:40396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0KZPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:04:34 -0500
Date: Fri, 26 Nov 2010 15:04:12 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, fbuihuu@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
References: <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Limit event refresh to sampling event
Message-ID: <tip-2e939d1da9b5628642314c1e68b4319e61263c94@git.kernel.org>
Git-Commit-ID: 2e939d1da9b5628642314c1e68b4319e61263c94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:04:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e939d1da9b5628642314c1e68b4319e61263c94
Gitweb:     http://git.kernel.org/tip/2e939d1da9b5628642314c1e68b4319e61263c94
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Tue, 23 Nov 2010 16:21:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:55 +0100

perf: Limit event refresh to sampling event

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290525705-6265-2-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8806984..027c4d3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1073,7 +1073,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	/*
 	 * not supported on inherited events
 	 */
-	if (event->attr.inherit)
+	if (event->attr.inherit || !is_sampling_event(event))
 		return -EINVAL;
 
 	atomic_add(refresh, &event->event_limit);
