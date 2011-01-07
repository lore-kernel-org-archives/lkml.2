Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1AGO0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:26:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1AGO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RmYgbgLBhdG2Bw2nCxfsdTmAodISqxat2QfImn3LvgSWYPoLPvJANIShFE5Xzzw5Kv
         k2wWixyzv2G6pm6Nfpkd5mr38p3tk/Q1OSY3+nxKzGqg1n054oCJc65vnxEP9vlIaa/E
         8vrLjfsNNNRSF58T+dzf2WoQwwQsaZH/ZboW4=
From: Richard Genoud <richard.genoud@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] spi_imx.c: correct the test on platform_get_irq() return value
Date: Fri,  7 Jan 2011 15:26:01 +0100
Message-Id: <1294410361-9092-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTimpTUz_Fizef09urPBR8vP80KU-5yApjzGWFwc0@mail.gmail.com>
References: <AANLkTimpTUz_Fizef09urPBR8vP80KU-5yApjzGWFwc0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test "if (spi_imx->irq <= 0)" is not testing the IRQ value, but the return value of platform_get_irq().
As platform_get_irq() can return an error (-ENXIO) or the IRQ value it found, the test should be "if (spi_imx->irq < 0)"

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 55a38e2..793ae99 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -847,7 +847,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 	}
 
 	spi_imx->irq = platform_get_irq(pdev, 0);
-	if (spi_imx->irq <= 0) {
+	if (spi_imx->irq < 0) {
 		ret = -EINVAL;
 		goto out_iounmap;
 	}
-- 
1.7.1

