Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2AMJBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:01:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2AMJBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:01:01 -0500
Message-ID: <1326445253.12667.1.camel@phoenix>
Subject: [PATCH] backlight: Return proper error in l4f00242t03_probe if
 regulator_get fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 13 Jan 2012 17:00:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/l4f00242t03.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index fae421a..6022b67 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -190,6 +190,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
+		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
 		goto err3;
@@ -197,6 +198,7 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
 	if (IS_ERR(priv->core_reg)) {
+		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
 		goto err4;
-- 
1.7.5.4



