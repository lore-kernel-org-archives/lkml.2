Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2KWXMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:12:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51269 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab2KWXMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:12:12 -0500
From: Andrea Adami <andrea.adami@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: pxa: pxa27x.c: add dummy SA1100 rtc clock
Date: Sat, 24 Nov 2012 00:12:08 +0100
Message-Id: <1353712328-15830-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Using pxa27x you could now build both RTC_DRV_PXA and RTC_DRV_SA1100.
* Make sure you don't use both together: link /dev/rtc0 or /dev/rtc1
* to /dev/rtc according to your requirement.

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/mach-pxa/pxa27x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 8047ee0..5970ebc 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -230,6 +230,7 @@ static struct clk_lookup pxa27x_clkregs[] = {
 	INIT_CLKREG(&clk_pxa27x_memc, NULL, "MEMCLK"),
 	INIT_CLKREG(&clk_pxa27x_mem, "pxa2xx-pcmcia", NULL),
 	INIT_CLKREG(&clk_dummy, "pxa-gpio", NULL),
+	INIT_CLKREG(&clk_dummy, "sa1100-rtc", NULL),
 };
 
 #ifdef CONFIG_PM
-- 
1.7.8.6

