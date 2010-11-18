Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0KRHBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:01:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37588 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab0KRHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AWj0KK4qaI847m0nXW8lWlwSxpJSHe3g1JwdNDtOI5/s2mykmyUh2+NCzhMs8Pvim7
         1lLGXVr5O32fAxmeQXtXkkDNeqJD8y9dDitzN7jR0q8+s2GTvu30XtZREDRM14/CYSqL
         a/sYjeU4OBd8DS/vIVsCZCx40SHWMI1QsbjrQ=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 3/5] MIPS/Perf-events: Check event state in validate_event()
Date: Thu, 18 Nov 2010 14:56:39 +0800
Message-Id: <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore events that are not for this PMU or are in off/error state.

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 1ee44a3..9c6442a 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -486,7 +486,7 @@ static int validate_event(struct cpu_hw_events *cpuc,
 {
 	struct hw_perf_event fake_hwc = event->hw;
 
-	if (event->pmu && event->pmu != &pmu)
+	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
 	return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
-- 
1.7.1

