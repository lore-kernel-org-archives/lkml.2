Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2C0CIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:08:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2C0CIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:08:38 -0400
Message-ID: <1332814105.21855.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: ad5398: show changing current in uA
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 10:08:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate the result.
Current code shows changing current is 0mA when selector is 1 ... 8.

For example:
selector = 1
ad5398_calc_current returns 117, debug message shows 117/1000 = 0mA
selector = 2
ad5398_calc_current returns 234, debug message shows 234/1000 = 0mA
selector = 3
ad5398_calc_current returns 351, debug message shows 351/1000 = 0mA
............
selector = 8
ad5398_calc_current returns 937, debug message shows 937/1000 = 0mA

Show the changing current in uA makes it easier for debugging.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 26d23ad..ed58798 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -99,8 +99,8 @@ static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int
 	if (ad5398_calc_current(chip, selector) > max_uA)
 		return -EINVAL;
 
-	dev_dbg(&client->dev, "changing current %dmA\n",
-		ad5398_calc_current(chip, selector) / 1000);
+	dev_dbg(&client->dev, "changing current %duA\n",
+		ad5398_calc_current(chip, selector));
 
 	/* read chip enable bit */
 	ret = ad5398_read_reg(client, &data);
-- 
1.7.5.4



