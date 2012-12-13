Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2LMWJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:09:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2LMWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 13/27] x86: use rsi/rdi to pass realmode_data pointer
Date: Thu, 13 Dec 2012 14:02:07 -0800
Message-Id: <1355436141-8668-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 64bit bootloader put real mode data above 4g, pointer will be
64bit instead of 32bit

use rsi/rdi instead of esi/edi for real_data pointer passing
between asm code and c code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 7d13874..4630d20 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -409,9 +409,9 @@ ENTRY(secondary_startup_64)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
-	/* esi is pointer to real mode structure with interesting info.
+	/* rsi is pointer to real mode structure with interesting info.
 	   pass it to C */
-	movl	%esi, %edi
+	movq	%rsi, %rdi
 	
 	/* Finally jump to run C code and to be on real kernel address
 	 * Since we are running on identity-mapped space we have to jump
-- 
1.7.10.4

