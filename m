Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2GXGvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:51:44 -0400
Received: from nbd.name ([46.4.11.11]:43457 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab2GXGvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:51:33 -0400
From: John Crispin <blogic@openwrt.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] GPIO: MIPS: lantiq: fix overflow inside stp-xway driver
Date: Tue, 24 Jul 2012 08:51:00 +0200
Message-Id: <1343112660-12245-6-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
References: <1343112660-12245-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was using a 16 bit field for storing the shadow value of the shift
register cascade. This resulted in only the first 2 shift registeres receiving
the correct data. The third shift register would always receive 0x00.

Fix this by using a 32bit field for the shadow value.

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpio/gpio-stp-xway.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-stp-xway.c b/drivers/gpio/gpio-stp-xway.c
index e35096b..8bead0b 100644
--- a/drivers/gpio/gpio-stp-xway.c
+++ b/drivers/gpio/gpio-stp-xway.c
@@ -82,7 +82,7 @@ struct xway_stp {
 	struct gpio_chip gc;
 	void __iomem *virt;
 	u32 edge;	/* rising or falling edge triggered shift register */
-	u16 shadow;	/* shadow the shift registers state */
+	u32 shadow;	/* shadow the shift registers state */
 	u8 groups;	/* we can drive 1-3 groups of 8bit each */
 	u8 dsl;		/* the 2 LSBs can be driven by the dsl core */
 	u8 phy1;	/* 3 bits can be driven by phy1 */
-- 
1.7.9.1

