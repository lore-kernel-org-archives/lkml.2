Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2H0RQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2H0RQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:16:40 -0400
Date: Mon, 27 Aug 2012 10:16:29 -0700
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-63a0bb0477012ed0f5c9e5658d0c7f08c291525c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1345916488-8355-12-git-send-email-fenghua.yu@intel.com>
References: <1345916488-8355-12-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86/i387.c:
  Initialize thread xstate only on CPU0 only once
Git-Commit-ID: 63a0bb0477012ed0f5c9e5658d0c7f08c291525c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:16:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63a0bb0477012ed0f5c9e5658d0c7f08c291525c
Gitweb:     http://git.kernel.org/tip/63a0bb0477012ed0f5c9e5658d0c7f08c291525c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Sat, 25 Aug 2012 10:41:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 25 Aug 2012 19:26:36 -0700

x86/i387.c: Initialize thread xstate only on CPU0 only once

init_thread_xstate() is only called once to avoid overriding xstate_size during
boot time or during CPU hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1345916488-8355-12-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..e4c3a21 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -188,7 +188,11 @@ void __cpuinit fpu_init(void)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
-	if (!smp_processor_id())
+	/*
+	 * init_thread_xstate is only called once to avoid overriding
+	 * xstate_size during boot time or during CPU hotplug.
+	 */
+	if (xstate_size == 0)
 		init_thread_xstate();
 
 	mxcsr_feature_mask_init();
