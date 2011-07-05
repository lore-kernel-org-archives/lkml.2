Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1GENKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:10:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61310 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1GENKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:10:14 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 09:10:14 EDT
X-IronPort-AV: E=Sophos;i="4.65,479,1304308800"; 
   d="scan'208";a="14928812"
From: Ian Campbell <ian.campbell@citrix.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: ret_from_fork: use symbolic contants for bits in EFLAGS
Date: Tue, 5 Jul 2011 14:00:14 +0100
Message-ID: <1309870814-14181-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110705111525.GR17941@sun>
References: <20110705111525.GR17941@sun>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/entry_32.S |    2 +-
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5c1a9197..f032530 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -303,7 +303,7 @@ ENTRY(ret_from_fork)
 	call schedule_tail
 	GET_THREAD_INFO(%ebp)
 	popl_cfi %eax
-	pushl_cfi $0x0202		# Reset kernel eflags
+	pushl_cfi $(X86_EFLAGS_IF|0x2)	# Reset kernel eflags
 	popfl_cfi
 	jmp syscall_exit
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9c28bd5..4c76abf 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -399,7 +399,7 @@ ENTRY(ret_from_fork)
 
 	call schedule_tail			# rdi: 'prev' task parameter
 
-	pushq_cfi $0x0202
+	pushq_cfi $(X86_EFLAGS_IF|0x2)
 	popfq_cfi				# reset kernel eflags
 
 	GET_THREAD_INFO(%rcx)
-- 
1.7.2.5

