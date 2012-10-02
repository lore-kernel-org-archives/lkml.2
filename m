Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2JBQhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2JBQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH 08/17] ARM: at91: unused variable in at91_pm_verify_clocks
Date: Tue,  2 Oct 2012 18:36:47 +0200
Message-Id: <1349195816-2225-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jYn0a1z0CG+/4gWpkTima/TbtUpf/iuD2eDHhQAoIGf
 xHHHj86CY0TJ/kx1jc5q3TGauYKG3toBFjWp8c+u0PKOWo5LFm
 IgkUrYW6YsxkVvfcDkopFbW02gJrfJ2rB0OuYF6T5SsTv8bYO5
 RPrhHwLF2zzk0cBe/QR/X3YbvY9goaJJ+pJqolZS7IsEp6x4Sf
 nW8Km2cT/pUSr4CnukYqvrNWaKMQ31yRhyzOHAcIG+XMMbBm5/
 sHhY9GZceJDrw3yeaqWTBGOTjIbGNCNwCuS0+hl94ErBV165eB
 H+0/znTlqOSinfMcnq+xpOkhaFGBf2LEwaFkRWff6Ydt/seOE6
 QcS1/5GrXjmt/jE5Muy3S3hHWvW/ztI36QUyKtauzWjDwi/g8F
 FNOU9ZJ5Hllvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code using the variable 'i' in this function is conditional, so
we have to make the declaration conditional as well to avoid a harmless
warning.

Without this patch, building at91sam9263_defconfig results in:

/home/arnd/linux-arm/arch/arm/mach-at91/pm.c: In function 'at91_pm_verify_clocks':
/home/arnd/linux-arm/arch/arm/mach-at91/pm.c:137:6: warning: unused variable 'i' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/pm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 2c2d865..cdd620d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -135,7 +135,9 @@ static int at91_pm_begin(suspend_state_t state)
 static int at91_pm_verify_clocks(void)
 {
 	unsigned long scsr;
+#ifdef CONFIG_AT91_PROGRAMMABLE_CLOCKS
 	int i;
+#endif
 
 	scsr = at91_pmc_read(AT91_PMC_SCSR);
 
-- 
1.7.10

