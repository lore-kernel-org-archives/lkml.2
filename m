Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0EXNNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:13:41 -0400
Received: from mail-pz0-f189.google.com ([209.85.222.189]:46239 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0EXNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:13:40 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 09:13:39 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wVVp+nigDH1/73xnKc623TcnWogHyYstuXiE0bxANTGtIQpW9B2k6aYbwecJuwo1Zw
         DeHO2qgp+/OSrVDwLmp9o8VOB6uohjy6ehAQdACR/68UDkVWuewKL7dTNadf/C8ikncu
         lJJWFGl96tGNd01XIPKK3VNJOOThVGaZ1ht9Q=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86/mm: remove unused DBG() macro
Date: Mon, 24 May 2010 22:04:51 +0900
Message-Id: <1274706291-13554-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DBG() macro for CONFIG_DEBUG_PER_CPU_MAPS is unused.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/setup_percpu.c |    6 ------
 arch/x86/mm/numa.c             |    6 ------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef6370b..3627998 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -21,12 +21,6 @@
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(fmt, ...) pr_dbg(fmt, ##__VA_ARGS__)
-#else
-# define DBG(fmt, ...) do { if (0) pr_dbg(fmt, ##__VA_ARGS__); } while (0)
-#endif
-
 DEFINE_PER_CPU(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 550df48..787c52c 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -3,12 +3,6 @@
 #include <linux/module.h>
 #include <linux/bootmem.h>
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(x...) printk(KERN_DEBUG x)
-#else
-# define DBG(x...)
-#endif
-
 /*
  * Which logical CPUs are on which nodes
  */
-- 
1.6.0.6

