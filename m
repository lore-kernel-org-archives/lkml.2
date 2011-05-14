Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1ENXdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 19:33:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51950 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1ENXdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 19:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iNdOU5/DjZ4S4/PjiOCBiOWvlHlCN9Mb3SeQF0whUhVUSGgI47QQxfqxK2LvxufKMy
         Ql5aqWMaK3yLj/b+AH1PvlIG+3+IkFcm8CHapLUamjUFUg1MtDFfeqRXiZ/574MIN39g
         CtlFVAPyYzgmh6tpxBK4nybL7f87UbNa59Ivg=
Subject: [PATCH 1/2] spi: spi_nuc900: Use spi_bitbang_stop instead of
 spi_unregister_master in nuc900_spi_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 07:33:28 +0800
Message-ID: <1305416008.24670.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling spi_bitbang_stop() will also destroy bitbang->workqueue,
which is created by calling spi_bitbang_start() in nuc900_spi_probe().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi_nuc900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_nuc900.c b/drivers/spi/spi_nuc900.c
index d5be18b..3cd15f6 100644
--- a/drivers/spi/spi_nuc900.c
+++ b/drivers/spi/spi_nuc900.c
@@ -463,7 +463,7 @@ static int __devexit nuc900_spi_remove(struct platform_device *dev)
 
 	platform_set_drvdata(dev, NULL);
 
-	spi_unregister_master(hw->master);
+	spi_bitbang_stop(&hw->bitbang);
 
 	clk_disable(hw->clk);
 	clk_put(hw->clk);
-- 
1.7.1



