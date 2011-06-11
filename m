Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1FKLjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:39:04 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53709 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab1FKLi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:38:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] net/m68k: Include <linux/interrupt.h> where needed
Date: Sat, 11 Jun 2011 13:38:55 +0200
Message-Id: <1307792335-9926-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/m68k/emu/nfeth.c: In function ‘nfeth_init’:
arch/m68k/emu/nfeth.c:243: error: implicit declaration of function ‘request_irq’
arch/m68k/emu/nfeth.c:243: error: ‘IRQF_SHARED’ undeclared (first use in this function)
arch/m68k/emu/nfeth.c:243: error: (Each undeclared identifier is reported only once
arch/m68k/emu/nfeth.c:243: error: for each function it appears in.)
arch/m68k/emu/nfeth.c: In function ‘nfeth_cleanup’:
arch/m68k/emu/nfeth.c:266: error: implicit declaration of function ‘free_irq’
drivers/net/apne.c: In function ‘apne_probe’:
drivers/net/apne.c:189: error: implicit declaration of function ‘free_irq’
drivers/net/apne.c: In function ‘apne_probe1’:
drivers/net/apne.c:317: error: implicit declaration of function ‘request_irq’
drivers/net/apne.c:317: error: ‘IRQF_SHARED’ undeclared (first use in this function)
drivers/net/apne.c:317: error: (Each undeclared identifier is reported only once
drivers/net/apne.c:317: error: for each function it appears in.)

Introduced by commit a6b7a407865a ("net: remove interrupt.h inclusion from
netdevice.h").

Include <linux/interrupt.h> in the individual drivers to fix the build.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/emu/nfeth.c |    1 +
 drivers/net/apne.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index 8b6e201..3c55312 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -16,6 +16,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <asm/natfeat.h>
 #include <asm/virtconvert.h>
diff --git a/drivers/net/apne.c b/drivers/net/apne.c
index 2fe60f1..5477373 100644
--- a/drivers/net/apne.c
+++ b/drivers/net/apne.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/interrupt.h>
 #include <linux/jiffies.h>
 
 #include <asm/system.h>
-- 
1.7.0.4

