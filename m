Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2BCHDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:03:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2BCHDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:03:32 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: [Patch] avr32: select GENERIC_ATOMIC64
Date: Fri,  3 Feb 2012 15:03:00 +0800
Message-Id: <1328252580-2630-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avr32 doesn't implement atomic64_ operations, if not select this,
we would get:

kernel/trace/trace_clock.c:117: error: syntax error before 'trace_counter'
kernel/trace/trace_clock.c:126: error: implicit declaration of function 'atomic64_add_return'

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 197e96f..6ecb8f4 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -11,6 +11,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_ATOMIC64
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
