Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1HEFqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:46:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38248 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1HEFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:46:22 -0400
From: xiyou.wangcong@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [Patch] cris: add arch/cris/include/asm/serial.h
Date: Fri,  5 Aug 2011 13:46:00 +0800
Message-Id: <1312523160-30345-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build errors:

src/drivers/tty/serial/8250_early.c:160: error: 'BASE_BAUD' undeclared (first use in this function): 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:160: error: (Each undeclared identifier is reported only once: 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:160: error: for each function it appears in.): 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:37:24: error: asm/serial.h: No such file or directory: 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig

I am not sure if (1843200 / 16) is suitable for cris, but
most of other arch's define it as this value.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/cris/include/asm/serial.h b/arch/cris/include/asm/serial.h
new file mode 100644
index 0000000..7380876
--- /dev/null
+++ b/arch/cris/include/asm/serial.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_SERIAL_H
+#define _ASM_SERIAL_H
+
+/*
+ * This assumes you have a 1.8432 MHz clock for your UART.
+ */
+#define BASE_BAUD (1843200 / 16)
+
+#endif /* _ASM_SERIAL_H */
+
