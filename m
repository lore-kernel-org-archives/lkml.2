Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab1FQI6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:56160 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457Ab1FQI5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:19 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/10] x86: provide arch-specific valid_phys_addr_range()
Date: Fri, 17 Jun 2011 10:48:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171048.05636.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default implementation in drivers/char/mem.c refuses to map high
memory, but since xlate_dev_mem_ptr() can now handle high memory on
x86, all physical addresses are valid.

We needn't check the available physical memory (or memory holes) here,
because these cases are handled by xlate_dev_mem_ptr (using pfn_valid).

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/include/asm/io.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 9b994dd..e3150fe 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -311,6 +311,17 @@ BUILDIO(b, b, char)
 BUILDIO(w, w, short)
 BUILDIO(l, , int)
 
+#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
+static inline int valid_phys_addr_range (phys_addr_t addr, size_t size)
+{
+	return 1;
+}
+
+static inline int valid_mmap_phys_addr_range (unsigned long pfn, size_t size)
+{
+	return 1;
+}
+
 extern void *xlate_dev_mem_ptr(phys_addr_t phys);
 extern void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
-- 
1.7.3.4
