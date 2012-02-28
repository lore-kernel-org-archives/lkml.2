Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059Ab2B1Su3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33988 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966018Ab2B1SuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:25 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 4/9] microblaze: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:33 -0800
Message-Id: <a980a9c855113fd613ee768a503f5bd5299efafd.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/microblaze/mm/pgtable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/mm/pgtable.c b/arch/microblaze/mm/pgtable.c
index 59bf233..e3a68bb 100644
--- a/arch/microblaze/mm/pgtable.c
+++ b/arch/microblaze/mm/pgtable.c
@@ -80,7 +80,7 @@ static void __iomem *__ioremap(phys_addr_t addr, unsigned long size,
 		!(p >= virt_to_phys((unsigned long)&__bss_stop) &&
 		p < virt_to_phys((unsigned long)__bss_stop))) {
 		printk(KERN_WARNING "__ioremap(): phys addr "PTE_FMT
-			" is RAM lr %p\n", (unsigned long)p,
+			" is RAM lr %pf\n", (unsigned long)p,
 			__builtin_return_address(0));
 		return NULL;
 	}
-- 
1.7.8.111.gad25c.dirty

