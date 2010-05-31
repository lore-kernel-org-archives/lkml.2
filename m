Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0EaIIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:08:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:58575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0EaIIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:08:11 -0400
Date: Mon, 31 May 2010 08:06:44 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1274706291-13554-1-git-send-email-akinobu.mita@gmail.com>
References: <1274706291-13554-1-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Remove unused DBG() macro
Message-ID: <tip-e565813ab95875af0d51a6bcd537068380bb06ea@git.kernel.org>
Git-Commit-ID: e565813ab95875af0d51a6bcd537068380bb06ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 08:06:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e565813ab95875af0d51a6bcd537068380bb06ea
Gitweb:     http://git.kernel.org/tip/e565813ab95875af0d51a6bcd537068380bb06ea
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Mon, 24 May 2010 22:04:51 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 10:01:53 +0200

x86/mm: Remove unused DBG() macro

DBG() macro for CONFIG_DEBUG_PER_CPU_MAPS is unused.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <1274706291-13554-1-git-send-email-akinobu.mita@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    6 ------
 arch/x86/mm/numa.c             |    6 ------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a867940..401ff10 100644
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
