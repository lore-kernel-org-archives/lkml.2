Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab1JAUI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:08:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1JAUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <samuel@sortiz.org>
Subject: [PATCH 15/26] irda/ficp: only works on some pxa models
Date: Sat,  1 Oct 2011 22:03:47 +0200
Message-Id: <1317499438-14058-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:d7OIvY6qYmMfjZpRQMN1t/KS/HO6M972eicZJjOKEtR
 kHtiy9kEol/V4ojdMLZJDw2260SOikTiSBiL+xuYDVHAsdVHHQ
 s0B+Kemkp7R52vtrnEHsdgqW4dijks4Z7W2SxlLz3a8uWqtEbm
 mMZVUqBi8OPNfdbBogP4687d007id4tnxAF6vkETnuodSewXIz
 OiNbffsb5FM96rQKdXzKRu//FDyz0APtZjFI4kcrplybHYS1zi
 RKBw1nEgImWMyp+u1Pdkfuf8895qSs7oFddEU7DWZ7s5dU63XW
 tsaMjtaWuyXN9Xz6LPC+WxCr/zpqP4msB4M736DWxrhveXYbf3
 QyGB0Hl/R6PYG/nuA8/01Nz5SA6ysZGWwdHzInpCLUyEFfSFHq
 uKmz9Pxr7rzdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can only be built for pxa25x and pxa27x at the moment,
so encode that in Kconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <samuel@sortiz.org>
---
 drivers/net/irda/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 25bb2a0..8cffd38 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -373,7 +373,7 @@ config VIA_FIR
 
 config PXA_FICP
 	tristate "Intel PXA2xx Internal FICP"
-	depends on ARCH_PXA && IRDA
+	depends on ARCH_PXA && IRDA && (PXA25x || PXA27x)
 	help
 	  Say Y or M here if you want to build support for the PXA2xx
 	  built-in IRDA interface which can support both SIR and FIR.
-- 
1.7.5.4

