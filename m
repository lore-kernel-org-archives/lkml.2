Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0JNGfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:35:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:43188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0JNGfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:35:24 -0400
Date: Thu, 14 Oct 2010 06:34:49 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        sfr@canb.auug.org.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
References: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, ARM: Fix sysfs bits removal build failure
Message-ID: <tip-1efeb08d7dd32c0fbd4b784ea9303b53d345bfd0@git.kernel.org>
Git-Commit-ID: 1efeb08d7dd32c0fbd4b784ea9303b53d345bfd0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 06:34:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1efeb08d7dd32c0fbd4b784ea9303b53d345bfd0
Gitweb:     http://git.kernel.org/tip/1efeb08d7dd32c0fbd4b784ea9303b53d345bfd0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 14 Oct 2010 08:09:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:09:42 +0200

perf, ARM: Fix sysfs bits removal build failure

Fix this linux-next build failure that Stephen reported:

 arch/arm/kernel/perf_event.c: In function 'armpmu_event_init':
 arch/arm/kernel/perf_event.c:543: error: request for member 'num_events' in something not a structure or union

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
LKML-Reference: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index ad19c27..55addc8 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -534,7 +534,7 @@ static int armpmu_event_init(struct perf_event *event)
 	event->destroy = hw_perf_event_destroy;
 
 	if (!atomic_inc_not_zero(&active_events)) {
-		if (atomic_read(&active_events) > armpmu.num_events) {
+		if (atomic_read(&active_events) > armpmu->num_events) {
 			atomic_dec(&active_events);
 			return -ENOSPC;
 		}
