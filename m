Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2LLCII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:08:08 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55864 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2LLCIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:08:06 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: r.sricharan@ti.com, santosh.shilimkar@ti.com, rmk+kernel@arm.linux.org.uk,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH] ARM: decompressor: Flush tlb before swiching domain 0 to client mode
Date: Tue, 11 Dec 2012 17:41:04 -0800
Message-Id: <1355276466-18295-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bootloader used a page table that is incompatible with domain 0
in client mode, then swithing domain 0 to client mode causes a fault
if we don't flush the tlb after updating the page table pointer.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/boot/compressed/head.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 90275f0..9c8034c 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -704,6 +704,7 @@ __armv7_mmu_cache_on:
 		bic     r6, r6, #1 << 31        @ 32-bit translation system
 		bic     r6, r6, #3 << 0         @ use only ttbr0
 		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
+		mcrne	p15, 0, r0, c8, c7, 0	@ flush I,D TLBs
 		mcrne	p15, 0, r1, c3, c0, 0	@ load domain access control
 		mcrne   p15, 0, r6, c2, c0, 2   @ load ttb control
 #endif
-- 
1.7.7.3

