Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0KRHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:01:56 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55752 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0KRHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eBIHbH1YCNDrx9shIllKgL16OSE80GFDhs6uPgfkk1VhWHaF9A63MBbAe8EsN5DZ8U
         AZHRTQvGTrXKv5B4W7ntdA6PFBssAYlESBPH/afnVyfI75OBwWlGboK+GlDLwdywABvx
         F0eWA1L3wL7UkI//IcnB2Z+NlZcZvwUuTfmNI=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 5/5] MIPS/Perf-events: Use unsigned delta for right shift in event update
Date: Thu, 18 Nov 2010 14:56:41 +0800
Message-Id: <1290063401-25440-6-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage the commit for ARM by Will Deacon:

446a5a8b1eb91a6990e5c8fe29f14e7a95b69132
	ARM: 6205/1: perf: ensure counter delta is treated as unsigned

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 345232a..0f1cdf5 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -169,7 +169,7 @@ static void mipspmu_event_update(struct perf_event *event,
 	unsigned long flags;
 	int shift = 64 - TOTAL_BITS;
 	s64 prev_raw_count, new_raw_count;
-	s64 delta;
+	u64 delta;
 
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-- 
1.7.1

