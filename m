Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2LMWIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:08:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50468 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab2LMWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:51 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 14/27] x86, kexec: remove 1024G limitation for kexec buffer on 64bit
Date: Thu, 13 Dec 2012 14:02:08 -0800
Message-Id: <1355436141-8668-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now 64bit kernel supports more than 1T ram and kexec tools
could find buffer above 1T, remove that obsolete limitation.
and use MAXMEM instead.

Tested on system more than 1024G ram.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/include/asm/kexec.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..11bfdc5 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -48,11 +48,11 @@
 # define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
 #else
 /* Maximum physical address we can use pages from */
-# define KEXEC_SOURCE_MEMORY_LIMIT      (0xFFFFFFFFFFUL)
+# define KEXEC_SOURCE_MEMORY_LIMIT      (MAXMEM-1)
 /* Maximum address we can reach in physical address mode */
-# define KEXEC_DESTINATION_MEMORY_LIMIT (0xFFFFFFFFFFUL)
+# define KEXEC_DESTINATION_MEMORY_LIMIT (MAXMEM-1)
 /* Maximum address we can use for the control pages */
-# define KEXEC_CONTROL_MEMORY_LIMIT     (0xFFFFFFFFFFUL)
+# define KEXEC_CONTROL_MEMORY_LIMIT     (MAXMEM-1)
 
 /* Allocate one page for the pdp and the second for the code */
 # define KEXEC_CONTROL_PAGE_SIZE  (4096UL + 4096UL)
-- 
1.7.10.4

