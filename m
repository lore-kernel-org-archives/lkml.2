Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1GYKDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:03:34 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37425 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1GYKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:03:28 -0400
X-IronPort-AV: E=Sophos;i="4.67,260,1309752000"; 
   d="scan'208";a="15236695"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: ret_from_fork: use symbolic contants for bits in EFLAGS
Date: Mon, 25 Jul 2011 11:03:07 +0100
Message-ID: <1311588187-20079-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
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

