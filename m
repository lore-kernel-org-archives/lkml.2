Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0IBNDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:03:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52771 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0IBNDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NacQc1SaYffHQbvdwtbvWqLQInulM46Qhq96/mTyHNjeNVfSjf7Wldap5tof/W7mED
         kAqnlbCtObcg2xwBo0TcLFqK0opjCrBoPVh7ABcNk4K9RZOlEhs7hWBo7vOoSt5q8Skm
         DhgvfhXNrklMWVEOFNhUC0yiM9y3FOzsbbWaE=
Date: Thu, 2 Sep 2010 15:37:10 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86, amd: Remove needless CPU family check (for L3 cache
 info)
Message-ID: <20100902133710.GA5449@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Old 32-bit AMD CPUs (all w/o L3 cache) should always return 0 for
cpuid_edx(0x80000006).

For unknown reason the 32-bit implementation differed from the 64-bit
implementation. See commit 67cddd947992b02f01ad093ec814738c5827d17c
(i386: Add L3 cache support to AMD CPUID4 emulation).
The current check is the result of the x86 merge.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fcf9895..a965b53 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -539,7 +539,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000006) {
-		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
+		if (cpuid_edx(0x80000006) & 0xf000)
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
-- 
1.6.4.4

