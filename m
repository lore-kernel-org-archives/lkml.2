Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2HWCRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:17:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:35290 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2HWCRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:17:40 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v2][PATCH 1/3] kgdb,ppc: do not set kgdb_single_step on ppc
Date: Thu, 23 Aug 2012 10:10:18 +0800
Message-ID: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.5.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb_single_step flag has the possibility to indefinitely
hang the system on an SMP system.

The x86 arch have the same problem, and that problem was fixed by
commit 8097551d9ab9b9e3630(kgdb,x86: do not set kgdb_single_step
on x86). This patch does the same behaviors as x86's patch.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
v2: nothing changed.

 arch/powerpc/kernel/kgdb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 782bd0a..bbabc5a 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -410,7 +410,6 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 #else
 			linux_regs->msr |= MSR_SE;
 #endif
-			kgdb_single_step = 1;
 			atomic_set(&kgdb_cpu_doing_single_step,
 				   raw_smp_processor_id());
 		}
-- 
1.5.6

