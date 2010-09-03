Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0ICIQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:16:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0ICIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:16:08 -0400
From: Bernhard Walle <walle@corscience.de>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, ddaney@caviumnetworks.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, hch@lst.de, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
Date: Fri,  3 Sep 2010 10:15:34 +0200
Message-Id: <1283501734-6532-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:80V1Up6k0zdnJ31H8L7+4YcvYB5b3HphSFXeOchfLvB
 PJmxnxjDizFnOMFLZy6OrXoa52hfKBImRO3aRy97PkVqsYVHQl
 X5F+qmtAHvlY89sVlzRbTEED21n0yWVU1XEvDvUrQWjoXsSoTG
 bFGlYRWtVTMZHYxxGigMHmQfUDUn705ztv33ubL24z5IrbSNlm
 +LYQRSUBr+lwyaPK+I6jQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 31c984a5acabea5d8c7224dc226453022be46f33 introduced a new syscall
getdents64. However, in the syscall table, the new syscall still refers
to the old getdents which doesn't work.

The problem appeared with a system that uses the eglibc 2.12-r11187
(that utilizes that new syscall) is very confused. The fix has been
tested with that eglibc version.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 arch/mips/kernel/scall64-n32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index a3d6613..dfa8cbc 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -419,5 +419,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_perf_event_open
 	PTR	sys_accept4
 	PTR     compat_sys_recvmmsg
-	PTR     sys_getdents
+	PTR     sys_getdents64
 	.size	sysn32_call_table,.-sysn32_call_table
-- 
1.7.0.4

