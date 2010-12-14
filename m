Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab0LNAth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:49:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757983Ab0LNAtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:49:35 -0500
Date: Tue, 14 Dec 2010 00:49:20 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, jody@nctritech.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, jody@nctritech.com
In-Reply-To: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
References: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
Message-ID: <tip-10340ae130fb70352eae1ae8a00b7906d91bf166@git.kernel.org>
Git-Commit-ID: 10340ae130fb70352eae1ae8a00b7906d91bf166
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 00:49:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10340ae130fb70352eae1ae8a00b7906d91bf166
Gitweb:     http://git.kernel.org/tip/10340ae130fb70352eae1ae8a00b7906d91bf166
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 16 Nov 2010 13:23:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:13:11 -0800

x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()

Alignment of alloc_bootmem() depends on the value of
L1_CACHE_SHIFT. What we need here, however, is 64 byte alignment.  Use
alloc_bootmem_align() and explicitly specify the alignment instead.

This fixes a kernel boot crash reported by Jody when the cpu in .config
is set to MPENTIUMII but the kernel is booted on a xsave-capable CPU.

Reported-by: Jody Bruchon <jody@nctritech.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/xsave.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9c253bd..5471285 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -394,7 +394,8 @@ static void __init setup_xstate_init(void)
 	 * Setup init_xstate_buf to represent the init state of
 	 * all the features managed by the xsave
 	 */
-	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf = alloc_bootmem_align(xstate_size,
+					      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 
 	clts();
