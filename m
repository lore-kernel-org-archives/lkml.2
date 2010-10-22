Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0JVNEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:04:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:40415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab0JVNEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:04:14 -0400
Date: Fri, 22 Oct 2010 13:03:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.354429461@chello.nl>
References: <20101019134808.354429461@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fixup the precise_ip computation
Message-ID: <tip-5553be2620ac901c21a25657bd5b59f73254e6d5@git.kernel.org>
Git-Commit-ID: 5553be2620ac901c21a25657bd5b59f73254e6d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:03:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5553be2620ac901c21a25657bd5b59f73254e6d5
Gitweb:     http://git.kernel.org/tip/5553be2620ac901c21a25657bd5b59f73254e6d5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:38:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:25 +0200

perf, x86: Fixup the precise_ip computation

In case we don't have PEBS, the LBR fixup doesn't make sense.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.354429461@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fe73c18..f369c53 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -497,12 +497,13 @@ static int x86_pmu_hw_config(struct perf_event *event)
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs)
+		if (x86_pmu.pebs) {
 			precise++;
 
-		/* Support for IP fixup */
-		if (x86_pmu.lbr_nr)
-			precise++;
+			/* Support for IP fixup */
+			if (x86_pmu.lbr_nr)
+				precise++;
+		}
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
