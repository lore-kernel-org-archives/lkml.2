Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2LEQJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:49 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2LEQJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:44 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 35/44] mm: define VM_GROWSUP for CONFIG_METAG
Date: Wed, 5 Dec 2012 16:08:53 +0000
Message-ID: <1354723742-6195-36-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cc2383ec06be093789469852e1fe96e1148e9a2c ("mm: introduce
arch-specific vma flag VM_ARCH_1") merged in v3.7-rc1.

The above commit combined several arch-specific vma flags into one, and
in the process it changed the VM_GROWSUP definition to depend on
specific architectures rather than CONFIG_STACK_GROWSUP. Therefore add
an ifdef for CONFIG_METAG to also set VM_GROWSUP.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 include/linux/mm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcaab4e..85c1df8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -114,6 +114,8 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SAO		VM_ARCH_1	/* Strong Access Ordering (powerpc) */
 #elif defined(CONFIG_PARISC)
 # define VM_GROWSUP	VM_ARCH_1
+#elif defined(CONFIG_METAG)
+# define VM_GROWSUP	VM_ARCH_1
 #elif defined(CONFIG_IA64)
 # define VM_GROWSUP	VM_ARCH_1
 #elif !defined(CONFIG_MMU)
-- 
1.7.7.6


