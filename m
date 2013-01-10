Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3AJQwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:52:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50204 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab3AJQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:51:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 06/14] mfd: omap-usb-host: update nports in platform_data
Date: Thu, 10 Jan 2013 18:51:26 +0200
Message-ID: <1357836694-30788-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHCI driver would need to know the number of ports available
on the platform. We set the nports parameter of platform_data
based on IP version if it was not already provided.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 7180b00..5c1c3ae 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -564,6 +564,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 			 omap->usbhs_rev, omap->nports);
 			break;
 		}
+		pdata->nports = omap->nports;
 	}
 
 	i = sizeof(struct clk *) * omap->nports;
-- 
1.7.4.1

