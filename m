Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2KOEwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:52:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58106 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab2KOEwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:52:46 -0500
Message-ID: <1352955159.6793.2.camel@phoenix>
Subject: [PATCH 2/4] pinctrl: kirkwood: Prevent NULL dereference if
 of_match_device returns NULL
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 12:52:39 +0800
In-Reply-To: <1352955096.6793.1.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_match_device() may return NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index 9a74ef6..fe885ca 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -444,8 +444,11 @@ static struct of_device_id kirkwood_pinctrl_of_match[] __devinitdata = {
 
 static int __devinit kirkwood_pinctrl_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match =
-		of_match_device(kirkwood_pinctrl_of_match, &pdev->dev);
+	const struct of_device_id *match;
+
+	match = of_match_device(kirkwood_pinctrl_of_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
 	pdev->dev.platform_data = match->data;
 	return mvebu_pinctrl_probe(pdev);
 }
-- 
1.7.9.5



