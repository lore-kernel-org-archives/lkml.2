Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1HWLSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:18:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33889 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:18:38 -0400
Date: Tue, 23 Aug 2011 14:18:24 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] arm: mach-bcmring: fix build error in core.c
Message-ID: <20110823111824.GA2806@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC      arch/arm/mach-bcmring/core.o
arch/arm/mach-bcmring/core.c: In function 'bcmring_init_timer':
arch/arm/mach-bcmring/core.c:238: error: implicit declaration of
function 'sp804_clockevents_register'
make[1]: *** [arch/arm/mach-bcmring/core.o] Error 1
make: *** [arch/arm/mach-bcmring] Error 2

Please let me know your comments on this fix:

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
index 43eadbc..430da12 100644
--- a/arch/arm/mach-bcmring/core.c
+++ b/arch/arm/mach-bcmring/core.c
@@ -235,7 +235,7 @@ void __init bcmring_init_timer(void)
 	 */
 	bcmring_clocksource_init();
 
-	sp804_clockevents_register(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
+	sp804_clockevents_init(TIMER0_VA_BASE, IRQ_TIMER0, "timer0");
 }
 
 struct sys_timer bcmring_timer = {
