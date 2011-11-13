Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1KMXBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:01:21 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40772 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1KMXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:01:20 -0500
Subject: [PATCH] [TRIVIAL] usb: gadget: drop "select
 USB_GADGET_S3C_HSOTG_PIO"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 00:01:12 +0100
Message-ID: <1321225272.20271.107.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol named USB_GADGET_S3C_HSOTG_PIO. The select
statement for that symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=arm menuconfig" before and after applying this
patch. Identical .config files were generated, as was expected.

1) This select statement was introduced in commit 5b7d70c6db ("USB:
Gadget driver for Samsung HS/OtG block"). I have no idea why.

2) This concludes this ad hoc series of Kconfig cleanups: select
statements with bogus Kconfig symbols. On to the next series, perhaps...

 drivers/usb/gadget/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index b21cd37..870a707 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -264,7 +264,6 @@ config USB_PXA27X
 config USB_S3C_HSOTG
 	tristate "S3C HS/OtG USB Device controller"
 	depends on S3C_DEV_USB_HSOTG
-	select USB_GADGET_S3C_HSOTG_PIO
 	select USB_GADGET_DUALSPEED
 	help
 	  The Samsung S3C64XX USB2.0 high-speed gadget controller
-- 
1.7.4.4

