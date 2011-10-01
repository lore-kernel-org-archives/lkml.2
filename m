Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1JAUFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab1JAUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 22/26] ARM: pxa: only select SMC91x on xcep when networking is enabled
Date: Sat,  1 Oct 2011 22:03:54 +0200
Message-Id: <1317499438-14058-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gkkV6bw47w7UwaW1YVsvtc/8X0QT5cj6iJEgwJ+KVrV
 nsc/li3EoPcHGRsH+2cIINBOJy8nCVxlGMKGVCUHIAHo52WPS+
 VDpYck9a3nE76a5bfyv3i/sJLCyA814+h2XtAf0pgjEAi8NMAH
 xH1m187gxiOCRsfygy4xRcZUoRnVVSUGE65W0zUje/XhYWx+Lt
 b/0eyx81384UH8MAW+vbrYwfmaNLnmjQBdrwY7bFE/QWTialYX
 qXdtXyk4p5niaW2m4q0IdtxeNlzzxp/A6tPJznnxPzz81Fmi7J
 HJ2XIyV8pOoamzqIrGHh2hbGFXOfDZ8rdr7tVLeFh0o/LhS4yu
 dxGUAhkuyBWwZelujaTgFcTvBqnC3wjXwCIEfB8UVRd8KfLl+L
 /GERZhPc/o83g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smc91x driver is not strictly required for xcep, but it
can only be enabled if ethernet support is built into the
kernel, so make the dependency more specific.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 491c522..ef35ce9 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -174,7 +174,7 @@ config MACH_XCEP
 	select MTD_CFI_INTELEXT
 	select MTD_CFI
 	select MTD_CHAR
-	select SMC91X
+	select SMC91X if NET_ETHERNET
 	help
 	  PXA255 based Single Board Computer with SMC 91C111 ethernet chip and 64 MB of flash.
 	  Tuned for usage in Libera instruments for particle accelerators.
-- 
1.7.5.4

