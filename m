Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2I0V4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:56:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2I0V4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:56:19 -0400
Date: Thu, 27 Sep 2012 14:56:01 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-f383a1e37bc3fc93d19ed23dfdb1adfc5a7d1010@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josh@joshtriplett.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, josh@joshtriplett.org, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <993c7f2ee7d53cc480280653a7df500db0882342.1347141698.git.josh@joshtriplett.org>
References: <993c7f2ee7d53cc480280653a7df500db0882342.1347141698.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi:
  Add a stub for efi_enter_virtual_mode on non-x86
Git-Commit-ID: f383a1e37bc3fc93d19ed23dfdb1adfc5a7d1010
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 14:56:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f383a1e37bc3fc93d19ed23dfdb1adfc5a7d1010
Gitweb:     http://git.kernel.org/tip/f383a1e37bc3fc93d19ed23dfdb1adfc5a7d1010
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sat, 8 Sep 2012 15:06:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Sep 2012 14:43:32 -0700

efi: Add a stub for efi_enter_virtual_mode on non-x86

This eliminates an ifdef in init/main.c.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/993c7f2ee7d53cc480280653a7df500db0882342.1347141698.git.josh@joshtriplett.org
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
