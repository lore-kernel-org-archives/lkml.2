Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2LMWEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:04:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50522 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2LMWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 25/27] x86, kdump: remove crashkernel range find limit for 64bit
Date: Thu, 13 Dec 2012 14:02:19 -0800
Message-Id: <1355436141-8668-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kexeced kernel/ramdisk could be above 4g, so remove 896 limit for
64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d0082a0..e73928a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -515,13 +515,11 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
- * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
- * limit once kexec-tools are fixed.
  */
 #ifdef CONFIG_X86_32
 # define CRASH_KERNEL_ADDR_MAX	(512 << 20)
 #else
-# define CRASH_KERNEL_ADDR_MAX	(896 << 20)
+# define CRASH_KERNEL_ADDR_MAX	MAXMEM
 #endif
 
 static void __init reserve_crashkernel(void)
-- 
1.7.10.4

