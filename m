Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2F1MIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:08:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60647 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2F1MIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:08:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] extcon: arizona: Stop microphone detection if we give up on it
Date: Thu, 28 Jun 2012 13:08:31 +0100
Message-Id: <1340885311-12368-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340885311-12368-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340885311-12368-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no point in continuing to try to detect a microphone any
more so stop doing so.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 0626754..427a289 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -196,6 +196,8 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		if (info->jack_flips >= info->micd_num_modes) {
 			dev_dbg(arizona->dev, "Detected headphone\n");
 			info->detecting = false;
+			arizona_stop_mic(info);
+
 			ret = extcon_set_cable_state_(&info->edev,
 						      ARIZONA_CABLE_HEADPHONE,
 						      true);
-- 
1.7.10

