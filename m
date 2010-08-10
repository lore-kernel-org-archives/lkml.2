Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0HJJLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:11:31 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58011 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab0HJJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:11:22 -0400
Date: Tue, 10 Aug 2010 11:11:19 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/4] arch/frv: Removing dead NO_KERNEL_MSG config option
Message-ID: <73b473d2bf994e9f8c9976eb160487d0d3782208.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_NO_KERNEL_MSG doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/frv/include/asm/bug.h   |    4 ----
 arch/frv/kernel/debug-stub.c |    2 --
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/frv/include/asm/bug.h b/arch/frv/include/asm/bug.h
index 2e05450..ea6e986 100644
--- a/arch/frv/include/asm/bug.h
+++ b/arch/frv/include/asm/bug.h
@@ -19,12 +19,8 @@
  */
 extern asmlinkage void __debug_bug_trap(int signr);
 
-#ifdef CONFIG_NO_KERNEL_MSG
-#define	_debug_bug_printk()
-#else
 extern void __debug_bug_printk(const char *file, unsigned line);
 #define	_debug_bug_printk() __debug_bug_printk(__FILE__, __LINE__)
-#endif
 
 #define _debug_bug_trap(signr)			\
 do {						\
diff --git a/arch/frv/kernel/debug-stub.c b/arch/frv/kernel/debug-stub.c
index 2845139..8752253 100644
--- a/arch/frv/kernel/debug-stub.c
+++ b/arch/frv/kernel/debug-stub.c
@@ -250,10 +250,8 @@ int __init console_get_baud(void)
 /*
  * display BUG() info
  */
-#ifndef CONFIG_NO_KERNEL_MSG
 void __debug_bug_printk(const char *file, unsigned line)
 {
 	printk("kernel BUG at %s:%d!\n", file, line);
 
 } /* end __debug_bug_printk() */
-#endif
-- 
1.7.0.4

