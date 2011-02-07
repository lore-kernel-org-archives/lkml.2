Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1BGT5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:57:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:23953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1BGT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292950"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 3/6] serial: ifx6x60: changed internal bpw from boolean to int
Date: Mon,  7 Feb 2011 12:02:29 -0800
Message-Id: <1297108952-27371-4-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver should support 32bit SPI transfers. The boolean variable
only allowed 8/16.

Changed to support 8/16/32 for future enabling
of 32 bpw.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index bb2ff20..9161cab 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -76,7 +76,7 @@
 static void ifx_spi_handle_srdy(struct ifx_spi_device *ifx_dev);
 
 /* local variables */
-static int spi_b16 = 1;			/* 8 or 16 bit word length */
+static int spi_bpw = 16;		/* 8, 16 or 32 bit word length */
 static struct tty_driver *tty_drv;
 static struct ifx_spi_device *saved_ifx_dev;
 static struct lock_class_key ifx_spi_key;
@@ -724,7 +724,7 @@ static void ifx_spi_io(unsigned long data)
 		ifx_dev->spi_xfer.cs_change = 0;
 		ifx_dev->spi_xfer.speed_hz = 12500000;
 		/* ifx_dev->spi_xfer.speed_hz = 390625; */
-		ifx_dev->spi_xfer.bits_per_word = spi_b16 ? 16 : 8;
+		ifx_dev->spi_xfer.bits_per_word = spi_bpw;
 
 		ifx_dev->spi_xfer.tx_buf = ifx_dev->tx_buffer;
 		ifx_dev->spi_xfer.rx_buf = ifx_dev->rx_buffer;
-- 
1.7.3.4

