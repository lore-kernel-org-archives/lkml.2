Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0IKIea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:34:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:39260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0IKIe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:34:28 -0400
Date: Sat, 11 Sep 2010 08:34:01 GMT
From: tip-bot for Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, benh@kernel.crashing.org, monstr@monstr.eu,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, monstr@monstr.eu,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <4C8B2A9A.1040303@kernel.org>
References: <4C8B2A9A.1040303@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock, microblaze: Fix memblock API change fallout
Message-ID: <tip-da5ab11cdfdf496448e0e9cdbbc2dfe207a96c94@git.kernel.org>
Git-Commit-ID: da5ab11cdfdf496448e0e9cdbbc2dfe207a96c94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 11 Sep 2010 08:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da5ab11cdfdf496448e0e9cdbbc2dfe207a96c94
Gitweb:     http://git.kernel.org/tip/da5ab11cdfdf496448e0e9cdbbc2dfe207a96c94
Author:     Michal Simek <monstr@monstr.eu>
AuthorDate: Sat, 11 Sep 2010 00:07:06 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Sep 2010 10:30:28 +0200

memblock, microblaze: Fix memblock API change fallout

Adopt Microblaze to the memblock API changes, to fix this
build failure:

  CC      arch/microblaze/mm/init.o
 arch/microblaze/mm/init.c: In function 'mm_cmdline_setup':
 arch/microblaze/mm/init.c:236: error: 'struct memblock_type' has no member named 'region'
 ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: linux-mm@kvack.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <4C8B2A9A.1040303@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/microblaze/mm/init.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 840026c..c843786 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -228,7 +228,7 @@ static void mm_cmdline_setup(void)
 		if (maxmem && memory_size > maxmem) {
 			memory_size = maxmem;
 			memory_end = memory_start + memory_size;
-			memblock.memory.region[0].size = memory_size;
+			memblock.memory.regions[0].size = memory_size;
 		}
 	}
 }
@@ -271,14 +271,14 @@ asmlinkage void __init mmu_init(void)
 		machine_restart(NULL);
 	}
 
-	if ((u32) memblock.memory.region[0].size < 0x1000000) {
+	if ((u32) memblock.memory.regions[0].size < 0x1000000) {
 		printk(KERN_EMERG "Memory must be greater than 16MB\n");
 		machine_restart(NULL);
 	}
 	/* Find main memory where the kernel is */
-	memory_start = (u32) memblock.memory.region[0].base;
-	memory_end = (u32) memblock.memory.region[0].base +
-				(u32) memblock.memory.region[0].size;
+	memory_start = (u32) memblock.memory.regions[0].base;
+	memory_end = (u32) memblock.memory.regions[0].base +
+				(u32) memblock.memory.regions[0].size;
 	memory_size = memory_end - memory_start;
 
 	mm_cmdline_setup(); /* FIXME parse args from command line - not used */
