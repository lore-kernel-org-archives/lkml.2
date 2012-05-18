Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030939Ab2ERC7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:59:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030721Ab2ERCws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:48 -0400
Message-Id: <20120518023258.981754890@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 34/53] spi-topcliff-pch: supports a spi mode setup and bit order setup by IO control
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit f258b44e22e07f5e98ac2260c70acff5784791b6 upstream.

This patch supports a spi mode setup and bit order setup by IO control.
    spi mode:     mode 0 to mode 3
    bit order:    LSB first, MSB first

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-topcliff-pch.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 4fdb83a..5a477e9 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1434,6 +1434,7 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
 	master->num_chipselect = PCH_MAX_CS;
 	master->setup = pch_spi_setup;
 	master->transfer = pch_spi_transfer;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
 
 	data->board_dat = board_dat;
 	data->plat_dev = plat_dev;
-- 
1.7.10



