Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2DAQyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:54:21 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:57209 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2DAQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:54:19 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: [PATCH] mips: cmpxchg: add missing include
Date: Sun,  1 Apr 2012 19:54:13 +0300
Message-Id: <1333299253-3308-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build breakage in v3.4-rc1:

  CC      kernel/irq_work.o
In file included from include/linux/irq_work.h:4:0,
                 from kernel/irq_work.c:10:
include/linux/llist.h: In function 'llist_del_all':
include/linux/llist.h:178:2: error: implicit declaration of function 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/include/asm/cmpxchg.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index 285a41f..eee10dc 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -8,6 +8,7 @@
 #ifndef __ASM_CMPXCHG_H
 #define __ASM_CMPXCHG_H
 
+#include <linux/bug.h>
 #include <linux/irqflags.h>
 #include <asm/war.h>
 
-- 
1.7.2.5

