Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JBQje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:39:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2JBQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Marek Vasut <marek.vasut@gmail.com>,
        Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 04/17] ARM: pxa: define palmte2_pxa_keys conditionally
Date: Tue,  2 Oct 2012 18:36:43 +0200
Message-Id: <1349195816-2225-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7B8gLeC1hpOkSCFc/PQDBdbou6/QfC9mBNB7VJaK/va
 OYsES2h/T9dNGlJg5CO5eMH4WKzvl7qPBvTM5sUQVVqpjROLT1
 fbl99b3DWhogK9jWMLskVpojvwdx6kokQPz3QsZPJhbrdwGcgc
 br2KEsrYRIi1istDA00Sh5oNWk6UfytlVz9wIbNn5sRv5Oi672
 STRGiqXjBiB4QUm3htsibgz6qcH+TltEM9bIs+bVHJ7gu57Zp6
 fwDh8DxV71Y7q1TIte7/a8UrdZHRyivFDx1gfrZ1bUfhWY0VeD
 eef8WNw9iT61LkhGb+emJWu4k10mlpeyN14cD0LTyxaO/QKiRx
 GEZc8H/bggjiidxFLqFDyPdmycQeIIH4Crc4PNEgPjeXlOKDFQ
 4Cozq/MxqADPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc prints a harmless warning about palmte2_pxa_keys not being used
when the gpio keyboard driver is disabled. The solution is to use
the same #ifdef that is already present in the place where the
symbol is used.

Without this patch, building palmz72_defconfig results in:

/home/arnd/linux-arm/arch/arm/mach-pxa/palmte2.c:128:31: warning: 'palmte2_pxa_keys' defined but not used [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Carlos Eduardo Medaglia Dyonisio <cadu@nerdfeliz.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
---
 arch/arm/mach-pxa/palmte2.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-pxa/palmte2.c b/arch/arm/mach-pxa/palmte2.c
index c054827..8497b28 100644
--- a/arch/arm/mach-pxa/palmte2.c
+++ b/arch/arm/mach-pxa/palmte2.c
@@ -105,6 +105,7 @@ static struct pxamci_platform_data palmte2_mci_platform_data = {
 	.gpio_power		= GPIO_NR_PALMTE2_SD_POWER,
 };
 
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 /******************************************************************************
  * GPIO keys
  ******************************************************************************/
@@ -132,6 +133,7 @@ static struct platform_device palmte2_pxa_keys = {
 		.platform_data = &palmte2_pxa_keys_data,
 	},
 };
+#endif
 
 /******************************************************************************
  * Backlight
-- 
1.7.10

