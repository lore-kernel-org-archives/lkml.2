Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0KZDEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:04:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62286 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0KZDES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:04:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BRDa8UfYgN+8nlHi+qnuatPIc3Ul+C9dUE8UdbcARlSdeUcNBGuE1HVtqUEgYK/OwU
         HZ0xOPlIUsV/QGhSpNp8TsfloA1WZco7Oi6Rtg368Aouoh2uvK9LYeW11gVGZ3la/Fez
         BB2iC6jIkoxOl/2ES0FdyJV8qM9ul1Y/TUPbE=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH v2 5/5] MIPS/Perf-events: Use unsigned delta for right shift in event update
Date: Fri, 26 Nov 2010 11:05:07 +0800
Message-Id: <1290740707-32586-6-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage the commit for ARM by Will Deacon:

446a5a8b1eb91a6990e5c8fe29f14e7a95b69132
        ARM: 6205/1: perf: ensure counter delta is treated as unsigned

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 8f7d2f8..a824485 100644
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

