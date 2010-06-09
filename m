Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0FILUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:20:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37149 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235Ab0FILUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:20:43 -0400
Date: Wed, 9 Jun 2010 13:20:41 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Yang Shi <yang.shi@windriver.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/9] Removing dead CONFIG_GDB_CONSOLE
Message-ID: <598418d662edd83225b8b47ead59a5cf18a26fc6.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GDB_CONSOLE doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/mips/cavium-octeon/serial.c    |    4 ----
 arch/mips/cavium-octeon/setup.c     |    4 ----
 arch/mips/pmc-sierra/yosemite/irq.c |    4 ----
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/mips/cavium-octeon/serial.c b/arch/mips/cavium-octeon/serial.c
index 83eac37..638adab 100644
--- a/arch/mips/cavium-octeon/serial.c
+++ b/arch/mips/cavium-octeon/serial.c
@@ -18,11 +18,7 @@
 
 #include <asm/octeon/octeon.h>
 
-#ifdef CONFIG_GDB_CONSOLE
-#define DEBUG_UART 0
-#else
 #define DEBUG_UART 1
-#endif
 
 unsigned int octeon_serial_in(struct uart_port *up, int offset)
 {
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index d1b5ffa..8c81a5c 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -578,9 +578,6 @@ void __init prom_init(void)
 	}
 
 	if (strstr(arcs_cmdline, "console=") == NULL) {
-#ifdef CONFIG_GDB_CONSOLE
-		strcat(arcs_cmdline, " console=gdb");
-#else
 #ifdef CONFIG_CAVIUM_OCTEON_2ND_KERNEL
 		strcat(arcs_cmdline, " console=ttyS0,115200");
 #else
@@ -589,7 +586,6 @@ void __init prom_init(void)
 		else
 			strcat(arcs_cmdline, " console=ttyS0,115200");
 #endif
-#endif
 	}
 
 	if (octeon_is_simulation()) {
diff --git a/arch/mips/pmc-sierra/yosemite/irq.c b/arch/mips/pmc-sierra/yosemite/irq.c
index 51021cf..25bbbf4 100644
--- a/arch/mips/pmc-sierra/yosemite/irq.c
+++ b/arch/mips/pmc-sierra/yosemite/irq.c
@@ -150,8 +150,4 @@ void __init arch_init_irq(void)
 	mips_cpu_irq_init();
 	rm7k_cpu_irq_init();
 	rm9k_cpu_irq_init();
-
-#ifdef CONFIG_GDB_CONSOLE
-	register_gdb_console();
-#endif
 }
-- 
1.6.3.3

