Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2CKNbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:31:14 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:58615 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2CKNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:31:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-usb@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs with CONFIG_USB_FUNCTIONFS_ETH
Date: Sun, 11 Mar 2012 14:31:10 +0100
Message-Id: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 28824b18ac4705e876a282a15ea0de8fc957551f:
|Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
|Date:   Wed May 5 12:53:13 2010 +0200
|
|    USB: gadget: __init and __exit tags removed
|
|    __init, __initdata and __exit tags have have been removed from
|    various files to make it possible for gadgets that do not use
|    the __init/__exit tags to use those.
obviously missed (at least) this case leading to a section mismatch in
g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/gadget/f_subset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index c154064..3974bc9 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -404,7 +404,7 @@ geth_unbind(struct usb_configuration *c, struct usb_function *f)
  * Caller must have called @gether_setup().  Caller is also responsible
  * for calling @gether_cleanup() before module unload.
  */
-int __init geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
+int geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN])
 {
 	struct f_gether	*geth;
 	int		status;
-- 
1.7.2.5

