Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab1DYUy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:54:27 -0400
Received: from 1wt.eu ([62.212.114.60]:33961 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab1DYUYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:15 -0400
Message-Id: <20110425200235.731317077@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Don Zickus <dzickus@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 063/173] x86: Use u32 instead of long to set reset vector back to 0
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
LKML-Reference: <1297139100-424-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: longterm-2.6.27/include/asm-x86/mach-default/smpboot_hooks.h
===================================================================
--- longterm-2.6.27.orig/include/asm-x86/mach-default/smpboot_hooks.h	2011-04-25 15:10:35.000000000 +0200
+++ longterm-2.6.27/include/asm-x86/mach-default/smpboot_hooks.h	2011-04-25 15:10:44.035278651 +0200
@@ -32,7 +32,7 @@
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *) phys_to_virt(0x467)) = 0;
+	*((volatile u32 *) phys_to_virt(0x467)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)


