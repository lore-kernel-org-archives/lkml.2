Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2IDVX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:23:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38817 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab2IDVX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:23:57 -0400
X-Originating-IP: 217.70.178.152
X-Originating-IP: 173.246.103.110
Date: Tue, 4 Sep 2012 14:23:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org
Subject: [PATCHv2 1/4] efi: Add a stub for efi_enter_virtual_mode on non-x86
Message-ID: <a3207a2f6dc5676d142dd1241aa87012d8cb148f.1346792566.git.josh@joshtriplett.org>
References: <cover.1346792566.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346792566.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates an ifdef in init/main.c.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/efi.h |    4 ++++
 init/main.c         |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec45ccd..52fbedf 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -495,7 +495,11 @@ extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
+#ifdef CONFIG_X86
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#else
+static void efi_enter_virtual_mode(void) {}
+#endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
diff --git a/init/main.c b/init/main.c
index b286730..ebb1ba5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -602,10 +602,8 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
-#ifdef CONFIG_X86
 	if (efi_enabled)
 		efi_enter_virtual_mode();
-#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
-- 
1.7.10.4

