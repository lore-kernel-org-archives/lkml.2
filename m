Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992878Ab2KOEvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:51:48 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46662 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992529Ab2KOEvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:51:47 -0500
Message-ID: <1352955096.6793.1.camel@phoenix>
Subject: [PATCH 1/4] pinctrl: dove: Prevent NULL dereference if
 of_match_device returns NULL
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 12:51:36 +0800
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
 drivers/pinctrl/mvebu/pinctrl-dove.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index ffe74b2..a8b9b42 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -578,8 +578,12 @@ static struct of_device_id dove_pinctrl_of_match[] __devinitdata = {
 
 static int __devinit dove_pinctrl_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match =
-		of_match_device(dove_pinctrl_of_match, &pdev->dev);
+	const struct of_device_id *match;
+
+	match = of_match_device(dove_pinctrl_of_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
+
 	pdev->dev.platform_data = match->data;
 
 	/*
-- 
1.7.9.5



