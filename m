Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1AFAET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:31905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1AFAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833871"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 1/7] serial: ifx6x60: fixed call to tty_port_init
Date: Wed,  5 Jan 2011 16:05:07 -0800
Message-Id: <1294272313-15899-2-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port ops must be set AFTER calling port init as that function
zeroes the structure

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index ab93763..1eb44f9 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
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
1.7.2.3

