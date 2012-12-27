Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2L0XVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:21:45 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60099 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2L0XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:21:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 4/4] arm: vt8500: Remove remaining mach includes
Date: Fri, 28 Dec 2012 12:20:52 +1300
Message-Id: <1356650452-16559-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last two mach-vt8500/include/mach headers as they are
no longer required with multiplatform-only configuration.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/mach-vt8500/include/mach/timex.h      |   26 -----------------
 arch/arm/mach-vt8500/include/mach/uncompress.h |   37 ------------------------
 2 files changed, 63 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/include/mach/timex.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/uncompress.h

diff --git a/arch/arm/mach-vt8500/include/mach/timex.h b/arch/arm/mach-vt8500/include/mach/timex.h
deleted file mode 100644
index 8487e4c..0000000
--- a/arch/arm/mach-vt8500/include/mach/timex.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/include/mach/timex.h
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#ifndef MACH_TIMEX_H
-#define MACH_TIMEX_H
-
-#define CLOCK_TICK_RATE		(3000000)
-
-#endif /* MACH_TIMEX_H */
diff --git a/arch/arm/mach-vt8500/include/mach/uncompress.h b/arch/arm/mach-vt8500/include/mach/uncompress.h
deleted file mode 100644
index e6e81fd..0000000
--- a/arch/arm/mach-vt8500/include/mach/uncompress.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* arch/arm/mach-vt8500/include/mach/uncompress.h
- *
- * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * Based on arch/arm/mach-dove/include/mach/uncompress.h
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#define UART0_PHYS	0xd8200000
-#define UART0_ADDR(x)	*(volatile unsigned char *)(UART0_PHYS + x)
-
-static void putc(const char c)
-{
-	while (UART0_ADDR(0x1c) & 0x2)
-		/* Tx busy, wait and poll */;
-
-	UART0_ADDR(0) = c;
-}
-
-static void flush(void)
-{
-}
-
-/*
- * nothing to do
- */
-#define arch_decomp_setup()
-#define arch_decomp_wdog()
-- 
1.7.9.5

