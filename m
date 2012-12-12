Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2LLExd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:53:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:63865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2LLExb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:53:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,264,1355126400"; 
   d="scan'208";a="256204898"
Subject: [PATCH] serial:ifx6x60:Keep word size accordance with SPI
 controller
From: chao bi <chao.bi@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: richardx.r.gorby@intel.com, jun.d.chen@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Dec 2012 13:07:06 +0800
Message-ID: <1355288826.30354.237.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As protocol driver, IFX SPI driver initiate to setup SPI master with default
SPI word size as 16 bit/word, however, SPI master may not adopt this default
value due to SPI controller's capability, it might choose an available value by
itself and set it to spi_device.bits_per_word. In order to keep align with
Controller, IFX driver should make use of this value during SPI transfer,
but the default one.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 675d94a..5919992 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -810,7 +810,8 @@ static void ifx_spi_io(unsigned long data)
 		ifx_dev->spi_xfer.cs_change = 0;
 		ifx_dev->spi_xfer.speed_hz = ifx_dev->spi_dev->max_speed_hz;
 		/* ifx_dev->spi_xfer.speed_hz = 390625; */
-		ifx_dev->spi_xfer.bits_per_word = spi_bpw;
+		ifx_dev->spi_xfer.bits_per_word =
+		ifx_dev->spi_dev->bits_per_word;
 
 		ifx_dev->spi_xfer.tx_buf = ifx_dev->tx_buffer;
 		ifx_dev->spi_xfer.rx_buf = ifx_dev->rx_buffer;
-- 
1.7.1



