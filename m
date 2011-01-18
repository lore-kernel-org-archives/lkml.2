Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1ARLYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 06:24:18 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:44821 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1ARLYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 06:24:17 -0500
Message-ID: <4D3578E3.5030700@dsn.okisemi.com>
Date: Tue, 18 Jan 2011 20:26:27 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-usb <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: [PATCH linux-next] usb: pch_udc: Fix the worning log issue at gadget
 driver remove
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing a serial gadget driver, the kernel warning message is outputted.
This patch fixed this issue.

The pch_udc driver did not have disconnection processing of gadget.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/usb/gadget/pch_udc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index dfe927b..025cf6c 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2716,7 +2716,8 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 
 	pch_udc_disable_interrupts(dev, UDC_DEVINT_MSK);
 
-	/* Assues that there are no pending requets with this driver */
+	/* Assures that there are no pending requests with this driver */
+	driver->disconnect(&dev->gadget);
 	driver->unbind(&dev->gadget);
 	dev->gadget.dev.driver = NULL;
 	dev->driver = NULL;
-- 
1.6.2.5
