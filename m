Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0IPOoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:44:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:39200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab0IPOoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:44:14 -0400
Date: Thu, 16 Sep 2010 14:43:26 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, peterz@infradead.org, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, peterz@infradead.org, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu
In-Reply-To: <4C91C544.5050907@kernel.org>
References: <4C91C544.5050907@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] arm, memblock: Fix the sparsemem build
Message-ID: <tip-7c996361ef0d02ef8c1435902c909d14195adcdc@git.kernel.org>
Git-Commit-ID: 7c996361ef0d02ef8c1435902c909d14195adcdc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 14:43:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c996361ef0d02ef8c1435902c909d14195adcdc
Gitweb:     http://git.kernel.org/tip/7c996361ef0d02ef8c1435902c909d14195adcdc
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 16 Sep 2010 00:20:36 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Sep 2010 09:35:12 +0200

arm, memblock: Fix the sparsemem build

Stephen Rothwell reported this build failure:

  arch/arm/mm/init.c: In function 'arm_memory_present':
  arch/arm/mm/init.c:260: warning: ISO C90 forbids mixed declarations and code

Caused by commit 719c1514f2 ("memblock/arm: Use new accessors")
which forgot a closing brace on a new for_each_memblock() in
arm_memory_present().

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
LKML-Reference: <4C91C544.5050907@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/mm/init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8504906..d6022d1 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -249,9 +249,8 @@ static void arm_memory_present(void)
 static void arm_memory_present(void)
 {
 	struct memblock_region *reg;
-	int i;
 
-	for_each_memblock(memory, reg) {
+	for_each_memblock(memory, reg)
 		memory_present(0, memblock_region_base_pfn(reg),
 			       memblock_region_end_pfn(reg));
 }
