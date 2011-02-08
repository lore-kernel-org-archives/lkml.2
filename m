Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1BHEZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:25:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1BHEZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:25:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] x86: use int instead of long to set reset vector back to 0
Date: Mon,  7 Feb 2011 23:25:00 -0500
Message-Id: <1297139100-424-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A customer of ours, complained that when setting the reset vector
back to 0, it trashed other data and hung their box.  They noticed
when only 4 bytes were set to 0 instead of 8, everything worked
correctly.

I don't know where to find this in the spec to know if this is
correct, but looking at historical info of the code, x86_64 used
to use 'int' here whereas i386 used to use 'long'.  When they got
merged it seemed like 'long' was used.  So the change seems to
make sense from that point of view.

I am hoping someone smarter than me can verify this.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 6c22bf3..42d0366 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile int *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
-- 
1.7.3.5

