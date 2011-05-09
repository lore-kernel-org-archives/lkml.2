Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1EIXQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:16:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:60057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab1EIXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:16:31 -0400
Date: Mon, 9 May 2011 23:16:22 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-2b5e8ef35bc89eee944c0627edacbb1fea5a1b84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1304623186-18261-1-git-send-email-mjg@redhat.com>
References: <1304623186-18261-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Remove virtual-mode SetVirtualAddressMap call
Git-Commit-ID: 2b5e8ef35bc89eee944c0627edacbb1fea5a1b84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 May 2011 23:16:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b5e8ef35bc89eee944c0627edacbb1fea5a1b84
Gitweb:     http://git.kernel.org/tip/2b5e8ef35bc89eee944c0627edacbb1fea5a1b84
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Thu, 5 May 2011 15:19:42 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 9 May 2011 12:14:25 -0700

x86, efi: Remove virtual-mode SetVirtualAddressMap call

The spec says that SetVirtualAddressMap doesn't work once you're in
virtual mode, so there's no point in having infrastructure for calling
it from there.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1304623186-18261-1-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
