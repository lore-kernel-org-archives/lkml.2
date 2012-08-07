Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2HGFNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 01:13:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:14639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab2HGFM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 01:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194031299"
Date: Tue, 7 Aug 2012 13:12:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russ Gorby <russ.gorby@intel.com>
Subject: [PATCH] serial: ifx6x60: fix paging fault on spi_register_driver
Message-ID: <20120807051247.GA24140@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  117.240866] BUG: unable to handle kernel paging request at 815b627c
[  117.240866] IP: [<813fe94b>] spi_register_driver+0xb/0x50
...
[  117.240866] Call Trace:
[  117.240866]  [<817de977>] ifx_spi_init+0xbe/0xf0

The root cause is, spi_register_driver() is trying to write into the
passed *const* struct spi_driver.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/drivers/tty/serial/ifx6x60.c	2012-05-24 19:03:07.408430953 +0800
+++ linux/drivers/tty/serial/ifx6x60.c	2012-08-07 12:57:05.499312357 +0800
@@ -1331,7 +1331,7 @@ static const struct spi_device_id ifx_id
 MODULE_DEVICE_TABLE(spi, ifx_id_table);
 
 /* spi operations */
-static const struct spi_driver ifx_spi_driver = {
+static struct spi_driver ifx_spi_driver = {
 	.driver = {
 		.name = DRVNAME,
 		.pm = &ifx_spi_pm,
