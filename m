Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1ASTUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:20:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:49607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab1ASTUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:20:06 -0500
Date: Wed, 19 Jan 2011 19:19:39 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, scottwood@freescale.com,
        benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, scottwood@freescale.com,
        benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110118214404.2f42e634@kryten>
References: <20110118214404.2f42e634@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] powerpc, perf: Fix frequency calculation for overflowing counters (FSL version)
Message-ID: <tip-8c8a9b25b5de3f1eeac721cf34f4379e56d5d694@git.kernel.org>
Git-Commit-ID: 8c8a9b25b5de3f1eeac721cf34f4379e56d5d694
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:19:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c8a9b25b5de3f1eeac721cf34f4379e56d5d694
Gitweb:     http://git.kernel.org/tip/8c8a9b25b5de3f1eeac721cf34f4379e56d5d694
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 18 Jan 2011 21:44:04 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 20:05:42 +0100

powerpc, perf: Fix frequency calculation for overflowing counters (FSL version)

When fixing the frequency calculations for perf on powerpc I
forgot to fix the FSL version.

If we dont set event->hw.last_period the frequency to period
calculations in perf go haywire and we continually
throttle/unthrottle the PMU.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110118214404.2f42e634@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event_fsl_emb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 4dcf5f8..b0dc8f7 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -596,6 +596,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			if (left <= 0)
 				left = period;
 			record = 1;
+			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
 			val = 0x80000000LL - left;
