Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab1CEBLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:11:05 -0500
Received: from kroah.org ([198.145.64.141]:50354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760469Ab1CEBAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.081254110@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Zickus <dzickus@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [46/73] x86: Use u32 instead of long to set reset vector back to 0
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)


