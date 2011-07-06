Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1GFUxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab1GFUxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:53:03 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: Don't use the EFI reboot method by default
Date: Wed,  6 Jul 2011 16:52:37 -0400
Message-Id: <1309985557-15350-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing suggests that at least some Lenovos and some Intels will fail
to reboot via EFI, attempting to jump to an unmapped physical address.
In the long run we could handle this by providing a page table with a
1:1 mapping of physical addresses, but for now it's probably just easier
to assume that ACPI or legacy methods will be present and reboot via those.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 06f6666..4f26568 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -540,9 +540,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
-- 
1.7.5.4

