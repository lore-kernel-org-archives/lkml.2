Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161272Ab2KOA2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:28:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161081Ab2KOA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:28:19 -0500
Date: Wed, 14 Nov 2012 16:27:49 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-6f5298c2139b06925037490367906f3d73955b86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-14-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-14-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86/i387.c:
  Initialize thread xstate only on CPU0 only once
Git-Commit-ID: 6f5298c2139b06925037490367906f3d73955b86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 16:28:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f5298c2139b06925037490367906f3d73955b86
Gitweb:     http://git.kernel.org/tip/6f5298c2139b06925037490367906f3d73955b86
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:50 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 15:28:11 -0800

x86/i387.c: Initialize thread xstate only on CPU0 only once

init_thread_xstate() is only called once to avoid overriding xstate_size during
boot time or during CPU hotplug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-14-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 675a050..245a71d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -175,7 +175,11 @@ void __cpuinit fpu_init(void)
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
