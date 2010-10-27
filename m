Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0J0JdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:33:16 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:4467 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab0J0JdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:33:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEyNx0zCTtAn/2dsb2JhbACDIJ44casYkXCBIoMydASKUw
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] m68k,m68knommu: Do not include linux/hardirq.h in asm/irqflags.h
Date: Wed, 27 Oct 2010 11:32:50 +0200
Message-Id: <1288171970-23818-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to header files made kernel compilation for m68k/m68knommu
fail with :
  CC      arch/m68knommu/kernel/asm-offsets.s
In file included from /archives/linux/git/arch/m68k/include/asm/system.h:2,
                 from include/linux/wait.h:25,
                 from include/linux/mmzone.h:9,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:12,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
                 from include/linux/hardirq.h:10,
                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
/archives/linux/git/arch/m68k/include/asm/system_no.h: In function ‘__xchg’:
/archives/linux/git/arch/m68k/include/asm/system_no.h:79: error: implicit
+declaration of function ‘local_irq_save’
/archives/linux/git/arch/m68k/include/asm/system_no.h:101: error: implicit
+declaration of function ‘local_irq_restore’

Fix that

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 arch/m68k/include/asm/irqflags.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/irqflags.h b/arch/m68k/include/asm/irqflags.h
index 4a5b284..38b414d 100644
--- a/arch/m68k/include/asm/irqflags.h
+++ b/arch/m68k/include/asm/irqflags.h
@@ -2,7 +2,6 @@
 #define _M68K_IRQFLAGS_H
 
 #include <linux/types.h>
-#include <linux/hardirq.h>
 #include <linux/preempt.h>
 #include <asm/thread_info.h>
 #include <asm/entry.h>
-- 
1.7.1

