Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2FQJXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 05:23:55 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:59363 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab2FQJXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 05:23:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] avr:  Fix sanitize tsk_is_polling fallout
Date: Sun, 17 Jun 2012 11:23:44 +0200
Message-Id: <1339925024-23323-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6222033ea7bfe166f06aff5462dd88fba70e74f6 ("sanitize tsk_is_polling()")
removed the definition of TIF_POLLING_NRFLAG, but forgot to remove the
continuation line, causing:

arch/avr32/include/asm/thread_info.h:80: error: expected identifier or '(' before numeric constant
include/linux/thread_info.h:128: error: implicit declaration of function 'set_ti_thread_flag'
make[2]: *** [arch/avr32/kernel/asm-offsets.s] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
http://kisskb.ellerman.id.au/kisskb/buildresult/6518296/
---
 arch/avr32/include/asm/thread_info.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index c034601..2f0c412 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -77,7 +77,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE       0       /* syscall trace active */
 #define TIF_SIGPENDING          1       /* signal pending */
 #define TIF_NEED_RESCHED        2       /* rescheduling necessary */
-					   TIF_NEED_RESCHED */
 #define TIF_BREAKPOINT		4	/* enter monitor mode on return */
 #define TIF_SINGLE_STEP		5	/* single step in progress */
 #define TIF_MEMDIE		6	/* is terminating due to OOM killer */
-- 
1.7.0.4

