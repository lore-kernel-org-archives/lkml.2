Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2FJOhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:37:54 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:58468 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2FJOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:37:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] frv: Fix use of extinct _sbss and _ebss in debug code
Date: Sun, 10 Jun 2012 16:37:49 +0200
Message-Id: <1339339070-24688-1-git-send-email-geert@linux-m68k.org>
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
index 75cf7f4..1294fdf 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -815,7 +815,7 @@ void __init setup_arch(char **cmdline_p)
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

