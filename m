Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1C1M1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:27:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1C1M13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:27:29 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: Remove spurious EFI error message
Date: Mon, 28 Mar 2011 08:27:13 -0400
Message-Id: <1301315233-2720-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.105.22.187
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI memory descriptor services can return a descriptor that is larger
than the specification, and right now we give a warning message in that
situation. This behaviour is permitted by the specification, so we should
just drop the warning.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0fe27d7..a902448 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -448,10 +448,6 @@ void __init efi_init(void)
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
-	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING
-		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
-
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
-- 
1.7.4.1

