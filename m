Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1H2FrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:47:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38524 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1H2FrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:47:08 -0400
Date: Mon, 29 Aug 2011 15:47:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (linus'
 tree related)
Message-Id: <20110829154704.776d9afeb0da5dacd958f5e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/head_64.o: In function `sys_call_table32':
(.text+0x223f8): undefined reference to `sys32_nfsservctl'

Presumably caused by commit f5b940997397 ("All Arch: remove linkage for
sys_nfsservctl system call") from Linus' tree.

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Aug 2011 15:43:40 +1000
Subject: [PATCH] sparc: Remove another reference to nfsservctl

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/systbls_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index c9296ab..edbec45 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -68,7 +68,7 @@ sys_call_table32:
 	.word compat_sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys32_mlockall
 /*240*/	.word sys_munlockall, sys32_sched_setparam, sys32_sched_getparam, sys32_sched_setscheduler, sys32_sched_getscheduler
 	.word sys_sched_yield, sys32_sched_get_priority_max, sys32_sched_get_priority_min, sys32_sched_rr_get_interval, compat_sys_nanosleep
-/*250*/	.word sys_mremap, compat_sys_sysctl, sys32_getsid, sys_fdatasync, sys32_nfsservctl
+/*250*/	.word sys_mremap, compat_sys_sysctl, sys32_getsid, sys_fdatasync, sys_nis_syscall
 	.word sys32_sync_file_range, compat_sys_clock_settime, compat_sys_clock_gettime, compat_sys_clock_getres, sys32_clock_nanosleep
 /*260*/	.word compat_sys_sched_getaffinity, compat_sys_sched_setaffinity, sys32_timer_settime, compat_sys_timer_gettime, sys_timer_getoverrun
 	.word sys_timer_delete, compat_sys_timer_create, sys_ni_syscall, compat_sys_io_setup, sys_io_destroy
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
