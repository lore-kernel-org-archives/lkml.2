Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3AJPpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:45:35 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54492 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3AJPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:32 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 01/44] asm-generic/io.h: check CONFIG_VIRT_TO_BUS
Date: Thu, 10 Jan 2013 15:30:29 +0000
Message-ID: <1357831872-29451-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make asm-generic/io.h check CONFIG_VIRT_TO_BUS before defining
virt_to_bus() and bus_to_virt(), otherwise it's easy to accidentally
have a silently failing incorrect direct mapped definition rather then
no definition at all.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/io.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 8e260cf..6b58e23 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -346,6 +346,7 @@ extern void ioport_unmap(void __iomem *p);
 #define xlate_dev_kmem_ptr(p)	p
 #define xlate_dev_mem_ptr(p)	__va(p)
 
+#ifdef CONFIG_VIRT_TO_BUS
 #ifndef virt_to_bus
 static inline unsigned long virt_to_bus(volatile void *address)
 {
@@ -357,6 +358,7 @@ static inline void *bus_to_virt(unsigned long address)
 	return (void *) address;
 }
 #endif
+#endif
 
 #ifndef memset_io
 #define memset_io(a, b, c)	memset(__io_virt(a), (b), (c))
-- 
1.7.7.6


