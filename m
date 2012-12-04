Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2LDG1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 01:27:54 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61421 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2LDG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 01:27:52 -0500
Message-ID: <1354602461.3286.1.camel@phoenix>
Subject: [PATCH RFT] spi: spi-xcomm: Fix wrong setting for
 SPI_XCOMM_SETTINGS_CPHA
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:27:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of setting SPI_XCOMM_SETTINGS_CPHA bit is reversed.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Lars,
The logic of setting SPI_XCOMM_SETTINGS_CPHA bit looks wrong to me.
Can you check if this patch works?

Thanks,
Axel

 drivers/spi/spi-xcomm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-xcomm.c b/drivers/spi/spi-xcomm.c
index 266a847..c2a3e8f 100644
--- a/drivers/spi/spi-xcomm.c
+++ b/drivers/spi/spi-xcomm.c
@@ -99,9 +99,9 @@ static int spi_xcomm_setup_transfer(struct spi_xcomm *spi_xcomm,
 		*settings &= ~SPI_XCOMM_SETTINGS_CPOL;
 
 	if (spi->mode & SPI_CPHA)
-		*settings &= ~SPI_XCOMM_SETTINGS_CPHA;
-	else
 		*settings |= SPI_XCOMM_SETTINGS_CPHA;
+	else
+		*settings &= ~SPI_XCOMM_SETTINGS_CPHA;
 
 	if (spi->mode & SPI_3WIRE)
 		*settings |= SPI_XCOMM_SETTINGS_3WIRE;
-- 
1.7.9.5



