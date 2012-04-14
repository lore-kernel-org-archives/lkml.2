Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2DNG0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:26:52 -0400
Received: from smtp15.mail.ru ([94.100.176.133]:46264 "EHLO smtp15.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2DNG01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:26:27 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm/sa1100: fix sa1100-rtc memory resource
Date: Sat, 14 Apr 2012 10:26:19 +0400
Message-Id: <1334384779-532-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.5.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_RES_MEM() takes the size of resource as a second argument,
not the end address. Passing end address leads to following error
in runtime during device registration:
sa1100-rtc: failed to claim resource 0

Fix it.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 arch/arm/mach-sa1100/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

For reference: bug was introduced by commit 3888c09074 
("rtc: sa1100: declare irq in resource")

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 7c524b4..16be4c5 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -306,7 +306,7 @@ void sa11x0_register_irda(struct irda_platform_data *irda)
 }
 
 static struct resource sa1100_rtc_resources[] = {
-	DEFINE_RES_MEM(0x90010000, 0x9001003f),
+	DEFINE_RES_MEM(0x90010000, 0x40),
 	DEFINE_RES_IRQ_NAMED(IRQ_RTC1Hz, "rtc 1Hz"),
 	DEFINE_RES_IRQ_NAMED(IRQ_RTCAlrm, "rtc alarm"),
 };
-- 
1.7.5.4

