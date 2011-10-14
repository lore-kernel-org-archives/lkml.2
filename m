Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1JNP7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:59:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1JNP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:59:15 -0400
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ccross@android.com, arnd@arndb.de,
        swarren@nvidia.com, pdeschrijver@nvidia.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: mutually exclude ZBOOT_ROM and AUTO_ZRELADDR
Date: Fri, 14 Oct 2011 08:59:05 -0700
Message-Id: <1318607945-6807-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20111014071500.GP21648@n2100.arm.linux.org.uk>
References: <20111014071500.GP21648@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way platforms that want it can select AUTO_ZRELADDR without issues caused by
someone manually also enabling ZBOOT_ROM.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


Russell King wrote at Friday, October 14, 2011 1:15 AM:

> I'll point out that this makes Tegra incompatible with ZBOOT_ROM, which
> can still be enabled.  ZBOOT_ROM=y AUTO_ZRELADDR=y is an invalid
> configuration at runtime.

Ah, looks like the dependency is only one-way. Since they are mutually
exclusive, how about the below?


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 82973b2..2ad58e8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1814,6 +1814,7 @@ config ZBOOT_ROM_BSS
 config ZBOOT_ROM
 	bool "Compressed boot loader in ROM/flash"
 	depends on ZBOOT_ROM_TEXT != ZBOOT_ROM_BSS
+	depends on !AUTO_ZRELADDR
 	help
 	  Say Y here if you intend to execute your compressed kernel image
 	  (zImage) directly from ROM or flash.  If unsure, say N.
-- 
1.7.4.1

