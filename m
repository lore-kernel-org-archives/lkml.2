Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BGT6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:58:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:23953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab1BGT5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292944"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 1/6] serial: ifx6x60: fixed call to tty_port_init
Date: Mon,  7 Feb 2011 12:02:27 -0800
Message-Id: <1297108952-27371-2-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port ops must be set AFTER calling port init as that function
zeroes the structure

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index c42de71..972c04d 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -798,8 +798,8 @@ static int ifx_spi_create_port(struct ifx_spi_device *ifx_dev)
 		goto error_ret;
 	}
 
-	pport->ops = &ifx_tty_port_ops;
 	tty_port_init(pport);
+	pport->ops = &ifx_tty_port_ops;
 	ifx_dev->minor = IFX_SPI_TTY_ID;
 	ifx_dev->tty_dev = tty_register_device(tty_drv, ifx_dev->minor,
 					       &ifx_dev->spi_dev->dev);
-- 
1.7.3.4

