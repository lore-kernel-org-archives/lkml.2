Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2EWHjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:39:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39497 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2EWHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:39:03 -0400
Date: Wed, 23 May 2012 09:38:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu change for v3.5
Message-ID: <20120523073857.GA9112@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: ddc5681ed33a279fdc188e98e71f0c539f08c6e6 x86/cache_info: Fix setup of l2/l3 ids

 Thanks,

	Ingo

------------------>
Shai Fultheim (1):
      x86/cache_info: Fix setup of l2/l3 ids


 arch/x86/kernel/cpu/intel_cacheinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b8f3653..9a7c90d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -615,14 +615,14 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 					new_l2 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(num_threads_sharing);
-					l2_id = c->apicid >> index_msb;
+					l2_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				case 3:
 					new_l3 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(
 							num_threads_sharing);
-					l3_id = c->apicid >> index_msb;
+					l3_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				default:
 					break;
