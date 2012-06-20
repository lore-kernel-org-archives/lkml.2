Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2FTL5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:57:52 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:34943 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2FTL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:57:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mn10300: Fix common threadinfo allocator fallout
Date: Wed, 20 Jun 2012 13:57:46 +0200
Message-Id: <1340193466-3342-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c03a6a7ba6f456663e4b254cdde460b24c0852e1 ("mn10300: Use common
threadinfo allocator") caused:

include/linux/thread_info.h: In function 'arch_release_thread_info':
include/linux/thread_info.h:70:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:75:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:80:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:85:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:90:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:127:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:132:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:136:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
include/linux/thread_info.h:140:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token

Add the missing semicolon, and revive the "extern" while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/include/asm/thread_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 08251d6..f374a76 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -123,7 +123,7 @@ static inline unsigned long current_stack_pointer(void)
 }
 
 #ifndef CONFIG_KGDB
-void arch_release_thread_info(struct thread_info *ti)
+extern void arch_release_thread_info(struct thread_info *ti);
 #endif
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
-- 
1.7.0.4

