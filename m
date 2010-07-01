Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab0GAVpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:45:41 -0400
Received: from kroah.org ([198.145.64.141]:32824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080Ab0GAVOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:14 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:55 2010
Message-Id: <20100701174255.380112746@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [106/200] ARM: 6139/1: ARMv7: Use the Inner Shareable I-cache on MP
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

commit a901ff715d53c109821cbbd9d7ea1f2a311646a9 upstream.

This patch fixes the flush_cache_all for ARMv7 SMP.It was
missing from commit b8349b569aae661dea9d59d7d2ee587ccea3336c

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 06a90dc..37c8157 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -91,7 +91,11 @@ ENTRY(v7_flush_kern_cache_all)
  THUMB(	stmfd	sp!, {r4-r7, r9-r11, lr}	)
 	bl	v7_flush_dcache_all
 	mov	r0, #0
+#ifdef CONFIG_SMP
+	mcr	p15, 0, r0, c7, c1, 0		@ invalidate I-cache inner shareable
+#else
 	mcr	p15, 0, r0, c7, c5, 0		@ I+BTB cache invalidate
+#endif
  ARM(	ldmfd	sp!, {r4-r5, r7, r9-r11, lr}	)
  THUMB(	ldmfd	sp!, {r4-r7, r9-r11, lr}	)
 	mov	pc, lr


