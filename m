Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2KPIyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:54:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22857 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2KPIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 9/9] x86: remove 1024g limitation for kexec buffer on 64bit
Date: Fri, 16 Nov 2012 00:53:09 -0800
Message-Id: <1353055989-31939-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could find buffer above that, remove that obsolete limitation.
use MAXMEM instead.

Tested on sytem more than 1024g ram.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/include/asm/kexec.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
1.7.7

