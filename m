Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1EETUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1EETUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:20:11 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] efi: Remove virtual-mode SetVirtualAddressMap call
Date: Thu,  5 May 2011 15:19:42 -0400
Message-Id: <1304623186-18261-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec says that SetVirtualAddressMap doesn't work once you're in
virtual mode, so there's no point in having infrastructure for calling
it from there.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0fe27d7..f2e4fe9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -145,17 +145,6 @@ static void virt_efi_reset_system(int reset_type,
 		       data_size, data);
 }
 
-static efi_status_t virt_efi_set_virtual_address_map(
-	unsigned long memory_map_size,
-	unsigned long descriptor_size,
-	u32 descriptor_version,
-	efi_memory_desc_t *virtual_map)
-{
-	return efi_call_virt4(set_virtual_address_map,
-			      memory_map_size, descriptor_size,
-			      descriptor_version, virtual_map);
-}
-
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -572,7 +561,7 @@ void __init efi_enter_virtual_mode(void)
 	efi.set_variable = virt_efi_set_variable;
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
-	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
+	efi.set_virtual_address_map = NULL;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
-- 
1.7.5

