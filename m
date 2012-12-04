Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2LDKb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:31:59 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:35081 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2LDKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:31:55 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -resend 1/2] frv: Fix use of extinct _sbss and _ebss in debug code
Date: Tue,  4 Dec 2012 11:31:46 +0100
Message-Id: <1354617107-21199-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays it should probably use __bss_start and __bss_stop

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/frv/kernel/setup.c |    2 +-
 arch/frv/mm/init.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index b8993c8..961e184 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -817,7 +817,7 @@ void __init setup_arch(char **cmdline_p)
 	printk("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x BSS=0x%06x-0x%06x\n",
 	       (int) &_stext, (int) &_etext,
 	       (int) &_sdata, (int) &_edata,
-	       (int) &_sbss, (int) &_ebss);
+	       (int) &__bss_start, (int) &__bss_stop);
 #endif
 
 #ifdef CONFIG_VT
diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index a19effc..92e97b0 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -146,7 +146,7 @@ void __init mem_init(void)
 
 #else
 	codek = (_etext - _stext) >> 10;
-	datak = 0; //(_ebss - _sdata) >> 10;
+	datak = 0; //(__bss_stop - _sdata) >> 10;
 #endif
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
-- 
1.7.0.4

