Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2IQK3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:29:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57387 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260Ab2IQK3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:29:12 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Olof Johansson <olof@lixom.net>, Peter Jones <pjones@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] x86: Switch to vga console only if framebuffer details are missing
Date: Mon, 17 Sep 2012 11:29:08 +0100
Message-Id: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The efi_enabled variable has come to mean "Do we have EFI runtime
services available?". However, lack of EFI runtime services does not
mean that we should switch to using the VGA console. Provided that the
boot loader passed the dimensions of the EFI framebuffer there is no
reason we can't use efifb.

There's also no reason to check the memory type of 0xa0000 - whether
or not that memory region is EFI_CONVENTIONAL_MEMORY is immaterial -
the EFI framebuffer device will still work, and checking the EFI
memory type of a memory region on a non-EFI machine is illogical.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Peter Jones <pjones@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..29dc30a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1021,7 +1021,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+	if (!screen_info.lfb_base || !screen_info.lfb_size)
 		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
-- 
1.7.4.4

