Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1JAUJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:09:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1JAUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 16/26] ARM: pxa: CPU_PJ4 requires IWMMXT
Date: Sat,  1 Oct 2011 22:03:48 +0200
Message-Id: <1317499438-14058-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AbtMddGtSFhin6vbvP6q2DaLgG4YTDWwb9AlOZtKwql
 lpH8nWV5b4h/sGONO8+ioiAVf2gKCag9ExOK7DeQv+96GK89Oq
 M0xflcm7i5tSaB7QDBW6OXEIvNsrVQvuvXosBI1OINCU1WmXGP
 /6nmLtALcyjllVB8999V2NicS4SMYiqzdmHKi3gaHCXvtQ4X0d
 EetmcTCts4NhxAQo1Ik086CUJFlpswuCXhySdZeblf4OFA7kik
 rpWWuEPopqm9bfrSYOAY8ZmVggi3Izg32nGTV/IkjMP1Zy4ReS
 sb5tpRjJ2/rQ8VWNnY7hvl5XqMw5Kz7oKYdGJBkkZqWOt26Usd
 ng58ugmOIyo/z3LezCGBGYWLZn4HYTazUKiOCvQF93MdvHjqv/
 9OaRQbrx6Jqgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PJ4 based pxa95x cpus all have iwmmxt and there is no way to
build that code conditionally, so better not ask the user
in that configuration, in order to prevent broken builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d9..570c9fd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1071,7 +1071,7 @@ config ARM_TIMER_SP804
 source arch/arm/mm/Kconfig
 
 config IWMMXT
-	bool "Enable iWMMXt support"
+	bool "Enable iWMMXt support" if !CPU_PJ4
 	depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_PJ4
 	default y if PXA27x || PXA3xx || PXA95x || ARCH_MMP
 	help
-- 
1.7.5.4

