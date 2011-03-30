Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab1C3Vbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:31:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006Ab1C3VIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133541"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dzickus@redhat.com, mjg@redhat.com, ak@linux.intel.com, mingo@elte.hu,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [162/275] x86: Use u32 instead of long to set reset vector back to 0
Message-Id: <20110330210644.4A10B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Don Zickus <dzickus@redhat.com>

commit 299c56966a72b9109d47c71a6db52097098703dd upstream.

A customer of ours, complained that when setting the reset
vector back to 0, it trashed other data and hung their box.
They noticed when only 4 bytes were set to 0 instead of 8,
everything worked correctly.

Mathew pointed out:

 |
 | We're supposed to be resetting trampoline_phys_low and
 | trampoline_phys_high here, which are two 16-bit values.
 | Writing 64 bits is definitely going to overwrite space
 | that we're not supposed to be touching.
 |

So limit the area modified to u32.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1297139100-424-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/include/asm/smpboot_hooks.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/smpboot_hooks.h	2011-03-29 22:51:00.390713170 -0700
+++ linux-2.6.35.y/arch/x86/include/asm/smpboot_hooks.h	2011-03-29 23:03:01.622258662 -0700
@@ -34,7 +34,7 @@
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
