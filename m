Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2LDKcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:32:13 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:35103 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2LDKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:31:55 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -resend 2/2] frv: Properly use the declarations provided by <asm/sections.h>
Date: Tue,  4 Dec 2012 11:31:47 +0100
Message-Id: <1354617107-21199-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354617107-21199-1-git-send-email-geert@linux-m68k.org>
References: <1354617107-21199-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Remove the superfluous address-of ('&') operators,
  - Remove the unneeded casts, use %p to format pointers instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/frv/kernel/setup.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 961e184..3cb3392 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -804,9 +804,9 @@ void __init setup_arch(char **cmdline_p)
 
 	BUG_ON(memory_start == memory_end);
 
-	init_mm.start_code = (unsigned long) &_stext;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
 #if 0 /* DAVIDM - don't set brk just incase someone decides to use it */
 	init_mm.brk = (unsigned long) &_end;
 #else
@@ -814,10 +814,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #ifdef DEBUG
-	printk("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x BSS=0x%06x-0x%06x\n",
-	       (int) &_stext, (int) &_etext,
-	       (int) &_sdata, (int) &_edata,
-	       (int) &__bss_start, (int) &__bss_stop);
+	printk("KERNEL -> TEXT=0x%p-0x%p DATA=0x%p-0x%p BSS=0x%p-0x%p\n",
+	       _stext, _etext, _sdata, _edata, __bss_start, __bss_stop);
 #endif
 
 #ifdef CONFIG_VT
-- 
1.7.0.4

