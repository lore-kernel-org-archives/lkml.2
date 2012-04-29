Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2D2Nku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:40:50 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:44122 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2D2Nkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:40:49 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Ian Campbell <ijc@hellion.org.uk>
Date: Sun, 29 Apr 2012 14:40:42 +0100
Message-Id: <1335706842-11725-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.7.10
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] ARM: kirkwood: add missing kexec.h include
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following build error when CONFIG_KEXEC is enabled:
  CC      arch/arm/mach-kirkwood/board-dt.o
arch/arm/mach-kirkwood/board-dt.c: In function 'kirkwood_dt_init':
arch/arm/mach-kirkwood/board-dt.c:52:2: error: 'kexec_reinit' undeclared (first use in this function)
arch/arm/mach-kirkwood/board-dt.c:52:2: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
[v4, rebase onto recent Linus for repost]
[v3, speak actual English in the commit message, thanks Sergei Shtylyov]
[v2, using linux/kexec.h not asm/kexec.h]
---
 arch/arm/mach-kirkwood/board-dt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 1c672d9..f7fe1b9 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/kexec.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <mach/bridge-regs.h>
-- 
1.7.10

