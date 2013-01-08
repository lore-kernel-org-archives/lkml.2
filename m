Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3AHXkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:40:20 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53799 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3AHXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 77/77] x86: Don't use the EFI reboot method by default
Date: Tue, 8 Jan 2013 18:35:56 -0500
Message-ID: <1357688156-25387-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f70e957cda22d309c769805cbb932407a5232219 upstream.

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
[PG: in 2.6.34, file is x86/platform/efi/efi.c --> x86/kernel/efi.c]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/efi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index c2fa9b8..0084548 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -459,9 +459,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
-- 
1.7.12.1

