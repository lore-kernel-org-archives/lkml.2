Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1JZU6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:58:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1JZU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:58:13 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: swarren@nvidia.com, linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] pinmux: Remove double pin validity check.
Date: Wed, 26 Oct 2011 22:57:20 +0200
Message-Id: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pin_is_valid just call pin_desc_get which is in pin_request
call some line below. Remove pin_is_valid() check.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/pinctrl/pinmux.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a5467f8..b6d964f 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -112,16 +112,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
 
 	dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
 
-	if (!pin_is_valid(pctldev, pin)) {
-		dev_err(&pctldev->dev, "pin is invalid\n");
-		return -EINVAL;
-	}
-
-	if (!function) {
-		dev_err(&pctldev->dev, "no function name given\n");
-		return -EINVAL;
-	}
-
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
 		dev_err(&pctldev->dev,
@@ -129,6 +119,11 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
+	if (!function) {
+		dev_err(&pctldev->dev, "no function name given\n");
+		return -EINVAL;
+	}
+
 	spin_lock(&desc->lock);
 	if (desc->mux_function) {
 		spin_unlock(&desc->lock);
-- 
1.7.5.4

