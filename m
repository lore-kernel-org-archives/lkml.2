Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab2KJX2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 18:28:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51600 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2KJX2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 18:28:16 -0500
Message-ID: <1352590084.14983.1.camel@phoenix>
Subject: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 07:28:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation in dove_audio1_ctrl_set() does not clear corresponding
register bit if BIT(0|1|2|3) of config is clear. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I don't have this hardware.
I'd appreciate if someone can review and test this patch.

Thanks,
Axel
 drivers/pinctrl/mvebu/pinctrl-dove.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index ffe74b2..e5cc694 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -236,12 +236,23 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 
 	if (config & BIT(0))
 		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
+	else
+		gcfg2 &= ~DOVE_TWSI_OPTION3_GPIO;
+
 	if (config & BIT(1))
 		gmpp |= DOVE_AU1_SPDIFO_GPIO_EN;
+	else
+		gmpp &= ~DOVE_AU1_SPDIFO_GPIO_EN;
+
 	if (config & BIT(2))
 		sspc1 |= DOVE_SSP_ON_AU1;
+	else
+		sspc1 &= ~DOVE_SSP_ON_AU1;
+
 	if (config & BIT(3))
 		mpp4 |= DOVE_AU1_GPIO_SEL;
+	else
+		mpp4 &= ~DOVE_AU1_GPIO_SEL;
 
 	writel(mpp4, DOVE_MPP_CTRL4_VIRT_BASE);
 	writel(sspc1, DOVE_SSP_CTRL_STATUS_1);
-- 
1.7.9.5



