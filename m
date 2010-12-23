Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0LWLMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:12:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0LWLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gjgl1xQgZXHDD39Ixijd182/WtVLLaiYnQKuWFSQ/Ghi6Je8b3ZDjIkWVFErukTYhd
         X+sgq9aLL3nLiK+mkQTFhcUqn6tHtprFFqQzXryg01RA81BIusUxiZV3yOqLroY6RnvR
         rD+w7RQp7wOl5xlCpKjFh6+ma4nI9b2iHF9lo=
From: Richard Genoud <richard.genoud@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/2] spi_imx.c: TRIVIAL mx25 & mx35 SPI_VER is 0.7
Date: Thu, 23 Dec 2010 12:12:10 +0100
Message-Id: <1293102730-32528-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com>
References: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check on cpu_is_mx25 and cpu_is_mx35 was made twice.
This is obviously wrong.
Anyway, this patch won't change the previous behaviour which is
SPI_IMX_VER_0_7 for mx25 and mx35.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 793ae99..96be9d1 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -806,7 +806,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 		if (cpu_is_mx25() || cpu_is_mx35())
 			spi_imx->devtype_data =
 				spi_imx_devtype_data[SPI_IMX_VER_0_7];
-		else if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35())
+		else if (cpu_is_mx31())
 			spi_imx->devtype_data =
 				spi_imx_devtype_data[SPI_IMX_VER_0_4];
 		else if (cpu_is_mx27() || cpu_is_mx21())
-- 
1.7.1

