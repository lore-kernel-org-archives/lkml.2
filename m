Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1FWCBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:01:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab1FWCA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BZ8VQipPspE3qaT926AkmYkwn9wc9UOR8EfBhoGLNcv0uYPu5SteosGDWyGPgpOE/2
         xcN+boKtUhJuYFYrKfwwZqd1ypfoM2Zyc8Hc5Ynyd8VgWqpqTrnW/4/ZgzmaWvsdyQPU
         eaUcqFhzsKyc1rAOkLCsZDiTMJzxAquqVkk4w=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 11/11] spi-dw: remove noop else clause
Date: Wed, 22 Jun 2011 19:00:13 -0700
Message-Id: <1308794413-11069-12-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The value of spi->bits_per_word is checked on function entry to be 8
or 16.  The else clause has no meaning since it can never be reached.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 7b3f607..5ddd45f 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -667,17 +667,14 @@ static int spi_dw_setup(struct spi_device *spi)
 		chip->enable_dma = chip_info->enable_dma;
 	}
 
-	if (spi->bits_per_word <= 8) {
+	if (spi->bits_per_word == 8) {
 		chip->n_bytes = 1;
 		chip->dma_width = 1;
-	} else if (spi->bits_per_word <= 16) {
+	} else if (spi->bits_per_word == 16) {
 		chip->n_bytes = 2;
 		chip->dma_width = 2;
-	} else {
-		/* Never take >16b case for DW SPIC */
-		dev_err(&spi->dev, "invalid wordsize\n");
-		return -EINVAL;
 	}
+
 	chip->bits_per_word = spi->bits_per_word;
 
 	chip->speed_hz = spi->max_speed_hz;
-- 
1.7.3.4

