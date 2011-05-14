Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab1ENXfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 19:35:22 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:65248 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab1ENXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 19:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pmqtkTdZBiSdgfOwJ6kutio1U10eB22P4YTFU+nSEtIuaqWKmhrf4ZQwXHETpbqmNJ
         Vis/01RddMRZ/zrVl+nKmB/E+rjftDHTQPssRRJjB+G4VNePad+3opWEIMJlbK/kJlp9
         LE31eYll+YvRbSTRea18AnmqGqrDXQzhw7AmM=
Subject: [PATCH 2/2] spi: spi_s3c24xx: Use spi_bitbang_stop instead of
 spi_unregister_master in s3c24xx_spi_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben@simtec.co.uk>, Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <1305416008.24670.1.camel@phoenix>
References: <1305416008.24670.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 07:35:16 +0800
Message-ID: <1305416116.24670.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling spi_bitbang_stop() will also destroy bitbang->workqueue,
which is created by calling spi_bitbang_start() in s3c24xx_spi_probe().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi_s3c24xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index 151a95e..1a5fcab 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -668,7 +668,7 @@ static int __exit s3c24xx_spi_remove(struct platform_device *dev)
 
 	platform_set_drvdata(dev, NULL);
 
-	spi_unregister_master(hw->master);
+	spi_bitbang_stop(&hw->bitbang);
 
 	clk_disable(hw->clk);
 	clk_put(hw->clk);
-- 
1.7.1



