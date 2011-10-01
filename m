Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1JAUHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:07:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab1JAUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 26/26] ARM: pxa: sharpsl pm needs SPI
Date: Sat,  1 Oct 2011 22:03:58 +0200
Message-Id: <1317499438-14058-27-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BxjlXuYNZRqAiGscVNHXx5AjMo4YSWLy5EviduvV6UQ
 tcNp12qGoqqlVkBRMXCPMEXbhgreCSQILG8/31jVIBU5EJnyg2
 f2eaA1hQDygRIqTom6LQwkhJD9bYnMALBWVXSJZ+jS7KPUeaZ7
 cScP3aAuLeuma4AP5TGCp8az4i2JcBgLDQomBkt5ic9MZ60IoX
 NjQ0U32YE9lUmSBl7eSHydimFM24l+ZtrtlIv9StgSp/2fge/7
 1cgOkOfeXtmroOEPbtoc4R7Qx3XZ9GdeXChqcv9WRzTytl4WTr
 O531p66QaUb6fJ10Pd04KZnCfwzDYoRoLlYXFXenyU4gvGBoZn
 UQEq+cuBIO/xakWDyKMly+wMzB75O1JCUPgbxM0Bu3J7rqWCEZ
 Lt72XKzAAhiog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sharpsl code selects the max1111 spi driver, so it must also
ensure that SPI itself is enabled. The platform does not work
without max1111.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 3733971..6dee18e 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -710,6 +710,8 @@ config SHARPSL_PM
 config SHARPSL_PM_MAX1111
 	bool
 	select HWMON
+	select SPI
+	select SPI_MASTER
 	select SENSORS_MAX1111
 
 config PXA_HAVE_ISA_IRQS
-- 
1.7.5.4

