Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0JBKB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:01:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46327 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0JBKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sH+2RKwLaWw3Z9EhiCbdr0BvZgEQuu8utpmRYu7Zi5zVpt1t1h00oU0X7WGaiyEmEX
         kr5hJxsRyhdnJl3GjoY9l+rloHEKxa4YFW1nhkpVDJtZuBzcL+jJqkqfwyILWccho2NW
         ++lJPFsV7xvThcYxs0x51MC3L7SwfS9m3HtW4=
Message-ID: <4CA71F94.8050703@gmail.com>
Date: Sat, 02 Oct 2010 14:03:32 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi-gpio: SPI_MASTER_NO_RX bit tested twice, missing SPI_MASTER_NO_TX?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPI_MASTER_NO_TX bit (can't do buffer write) wasn't tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/spi/spi_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Is this what was intended?

diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index e24a634..63e51b0 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -350,7 +350,7 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	spi_gpio->bitbang.master = spi_master_get(master);
 	spi_gpio->bitbang.chipselect = spi_gpio_chipselect;
 
-	if ((master_flags & (SPI_MASTER_NO_RX | SPI_MASTER_NO_RX)) == 0) {
+	if ((master_flags & (SPI_MASTER_NO_TX | SPI_MASTER_NO_RX)) == 0) {
 		spi_gpio->bitbang.txrx_word[SPI_MODE_0] = spi_gpio_txrx_word_mode0;
 		spi_gpio->bitbang.txrx_word[SPI_MODE_1] = spi_gpio_txrx_word_mode1;
 		spi_gpio->bitbang.txrx_word[SPI_MODE_2] = spi_gpio_txrx_word_mode2;
