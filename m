Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2GDFfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:35:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2GDFfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:35:05 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] h8300: fix a compile error in arch/h8300/kernel/time.c
Date: Wed,  4 Jul 2012 13:34:35 +0800
Message-Id: <1341380078-18580-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On h8300 we got:
arch/h8300/kernel/time.c:39:2: error: implicit declaration of function 'get_irq_regs' [-Werror=implicit-function-declaration]

this is due to we forgot to #include <asm/irq_regs.h>.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 32263a1..20d2140 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -28,6 +28,7 @@
 
 #include <asm/io.h>
 #include <asm/timer.h>
+#include <asm/irq_regs.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
 
