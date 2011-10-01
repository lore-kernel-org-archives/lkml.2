Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1JAUIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:08:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1JAUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 25/26] ARM: pxa: eseries does not require FB
Date: Sat,  1 Oct 2011 22:03:57 +0200
Message-Id: <1317499438-14058-26-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Ud+35oO1t2R/1W4/LjlppSqOgw8ib2gFG4RUb80k5jM
 WTplCrtVOoK4mIv9PeYc663Ni+rXkWoKIuIatf0J6AI/9s89Md
 erofUhlGxcMILntmOyxcrMXHs2UqwjQ+GsvZkLJRT+w+qmMeyR
 SCkx/MLkzwpbPtudahkIwWA4HjISf0Rfysx/DWSiY+GWTCHDVw
 1E1iBaRJO5PtRLwsihX/UP+A0qAKH7/UIb8buASaF1YCkGn17k
 H0T5ih0zYzg1knGjslU3Xj8Is6IJS46hrlfDEH4YxlmRyKSYtD
 X+0PL32jASAXhCd1KBnhg2kks3rwlPooclvgfoqrFh4XbK9Ajb
 SVOay+lvA+qz1tI6zoLdoNl4yiVLd+RGweloas0YVjIHTCfdoD
 b6rTOnhkr8SyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to build a kernel for eseries without framebuffer support,
so it must not select the w100 driver unconditionally.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index da6fca0..3733971 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -566,7 +566,7 @@ config MACH_ICONTROL
 config ARCH_PXA_ESERIES
 	bool "PXA based Toshiba e-series PDAs"
 	select PXA25x
-	select FB_W100
+	select FB_W100 if FB=y
 
 config MACH_E330
 	bool "Toshiba e330"
-- 
1.7.5.4

