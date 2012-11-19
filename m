Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2KSJkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:40:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KSJkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:40:13 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pinctrl: mvebu: Fix dove_audio1_ctrl_set function
Date: Mon, 19 Nov 2012 10:39:54 +0100
Message-Id: <1353317996-20841-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

When setting audio1 pinmux the bits in the corresponding registers
are not cleared. This fix first clears all bits and then sets the
required bits according to the selected function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 34693f6..40c9c3e 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -234,6 +234,14 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
+	/*
+	 * clear all audio1 related bits before configure
+	 */
+	gcfg2 &= ~DOVE_TWSI_OPTION3_GPIO;
+	gmpp &= ~DOVE_AU1_SPDIFO_GPIO_EN;
+	sspc1 &= ~DOVE_SSP_ON_AU1;
+	mpp4 &= ~DOVE_AU1_GPIO_SEL;
+
 	if (config & BIT(0))
 		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
 	if (config & BIT(1))
-- 
1.7.10.4

