Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab1JAUHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:07:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab1JAUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/26] ARM: pxa: move z2 to generic cpu_suspend
Date: Sat,  1 Oct 2011 22:03:40 +0200
Message-Id: <1317499438-14058-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PSoexy2x0ED08LEV4JRXsZuGqmz1iejG4JrmuadTtBd
 fspjKOk2CGEwZ9Zmr8lH1Y/7K8hLdrXqoUU0prnH+aAQOSdIuB
 abZxkgAPSkCTuPOporQVfpLAot+F0ymInur8UqmvA9Szdv6sMd
 iY3eYbRngC42QrediQMEIO0L25zEXKUhFGXHaFWcw2LMpvz6tM
 XpUSFMax2N+rzSjic5H0TlGspdb53d2m3Kb2cuocE4wfym9K9A
 YJdV7wSF3gz3CqJoVq/94Lky/ILVD4iXct4z1IAtMPFfKOaW1o
 RWpcD+yuBbalmZaKfCIOAL9vcHvu8XBySW/msYXz3/+WkQfcIW
 DEN+7DCfuzVX7il7nMMPd995bVu2+5CsJbCbdNViYtb9ZX16d9
 UjKQn7D6lOuog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_suspend code on pxa has recently changed, and the
z2 board did not get updated yet. This makes it do the
same as the other boards.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/z2.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 6c9275a..109447b 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/i2c/pxa-i2c.h>
 
+#include <asm/suspend.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
@@ -686,7 +687,7 @@ static void z2_power_off(void)
 	 */
 	PSPR = 0x0;
 	local_irq_disable();
-	pxa27x_cpu_suspend(PWRMODE_DEEPSLEEP, PLAT_PHYS_OFFSET - PAGE_OFFSET);
+	cpu_suspend(PWRMODE_DEEPSLEEP, pxa27x_finish_suspend);
 }
 #else
 #define z2_power_off   NULL
-- 
1.7.5.4

