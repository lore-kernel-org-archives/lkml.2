Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1AFAFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:05:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:31905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1AFAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833894"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 3/7] serial: ifx6x60: changed internal bpw from boolean to int
Date: Wed,  5 Jan 2011 16:05:09 -0800
Message-Id: <1294272313-15899-4-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver should support 32bit SPI transfers. The boolean variable
only allowed 8/16.

Changed to support 8/16/32 for future enabling
of 32 bpw.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index e18ae38..fd10103 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
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
1.7.2.3

