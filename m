Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2BJPCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:02:25 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42903 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177Ab2BJPCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:02:22 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco_usb: fix -Wunused-variable, remove version
Date: Fri, 10 Feb 2012 16:02:13 +0100
Message-Id: <1328886133-22757-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328886142;d583b641;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d632eb1bf22e11def74e4e53cc47d790fbdba105 removed
usage of version[], remove no longer needed variable and
print version instead in ezusb_probe().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index ae8ce56..2b413cf 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1583,6 +1583,8 @@ static int ezusb_probe(struct usb_interface *interface,
 	int retval = 0;
 	int i;
 
+	printk(KERN_DEBUG DRIVER_NAME " " DRIVER_VERSION);
+
 	priv = alloc_orinocodev(sizeof(*upriv), &udev->dev,
 				ezusb_hard_reset, NULL);
 	if (!priv) {
@@ -1754,11 +1756,6 @@ static struct usb_driver orinoco_driver = {
 	.id_table = ezusb_table,
 };
 
-/* Can't be declared "const" or the whole __initdata section will
- * become const */
-static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
-	" (Manuel Estrada Sainz)";
-
 module_usb_driver(orinoco_driver);
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
-- 
1.7.7.3

