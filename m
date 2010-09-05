Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0IENGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:06:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:53174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab0IENGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:06:11 -0400
Date: Sun, 5 Sep 2010 13:05:41 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, andreas.herrmann3@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, andreas.herrmann3@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100902133710.GA5449@loge.amd.com>
References: <20100902133710.GA5449@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, AMD: Remove needless CPU family check (for L3 cache info)
Message-ID: <tip-d9fadd7ba99a67030783a212bcb17d11f0678433@git.kernel.org>
Git-Commit-ID: d9fadd7ba99a67030783a212bcb17d11f0678433
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:05:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9fadd7ba99a67030783a212bcb17d11f0678433
Gitweb:     http://git.kernel.org/tip/d9fadd7ba99a67030783a212bcb17d11f0678433
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 2 Sep 2010 15:37:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:33:48 +0200

x86, AMD: Remove needless CPU family check (for L3 cache info)

Old 32-bit AMD CPUs (all w/o L3 cache) should always return 0
for cpuid_edx(0x80000006).

For unknown reason the 32-bit implementation differed from the
64-bit implementation. See commit 67cddd94799 ("i386: Add L3 cache
support to AMD CPUID4 emulation"). The current check is the
result of the x86 merge.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <20100902133710.GA5449@loge.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fc563fa..0f0ace5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -540,7 +540,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000006) {
-		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
+		if (cpuid_edx(0x80000006) & 0xf000)
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
