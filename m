Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0LPKnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:36123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab0LPKnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:43:17 -0500
Date: Thu, 16 Dec 2010 10:42:45 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, error27@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        error27@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101024195041.GT5985@bicker>
References: <20101024195041.GT5985@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix off by one in perf_swevent_init()
Message-ID: <tip-ce677831a4abd0f9f957c90ac6f6a0d0472bafb4@git.kernel.org>
Git-Commit-ID: ce677831a4abd0f9f957c90ac6f6a0d0472bafb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 10:42:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce677831a4abd0f9f957c90ac6f6a0d0472bafb4
Gitweb:     http://git.kernel.org/tip/ce677831a4abd0f9f957c90ac6f6a0d0472bafb4
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Sun, 24 Oct 2010 21:50:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:14:31 +0100

perf: Fix off by one in perf_swevent_init()

The perf_swevent_enabled[] array has PERF_COUNT_SW_MAX elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101024195041.GT5985@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7b87017..2870fee 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4719,7 +4719,7 @@ static int perf_swevent_init(struct perf_event *event)
 		break;
 	}
 
-	if (event_id > PERF_COUNT_SW_MAX)
+	if (event_id >= PERF_COUNT_SW_MAX)
 		return -ENOENT;
 
 	if (!event->parent) {
