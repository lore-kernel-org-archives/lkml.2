Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1GGPIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:08:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:57384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1GGPIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:08:44 -0400
Date: Thu, 7 Jul 2011 15:08:31 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-f70e957cda22d309c769805cbb932407a5232219@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, mjg@redhat.com,
        hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1309985557-15350-1-git-send-email-mjg@redhat.com>
References: <1309985557-15350-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't use the EFI reboot method by default
Git-Commit-ID: f70e957cda22d309c769805cbb932407a5232219
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 15:08:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f70e957cda22d309c769805cbb932407a5232219
Gitweb:     http://git.kernel.org/tip/f70e957cda22d309c769805cbb932407a5232219
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Wed, 6 Jul 2011 16:52:37 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 Jul 2011 11:35:05 +0200

x86: Don't use the EFI reboot method by default

Testing suggests that at least some Lenovos and some Intels will
fail to reboot via EFI, attempting to jump to an unmapped
physical address. In the long run we could handle this by
providing a page table with a 1:1 mapping of physical addresses,
but for now it's probably just easier to assume that ACPI or
legacy methods will be present and reboot via those.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/1309985557-15350-1-git-send-email-mjg@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/efi/efi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 474356b..899e393 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -504,9 +504,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
