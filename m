Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030822Ab2GMFfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:35:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34449 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030245Ab2GMFfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:35:00 -0400
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>, Felipe Balbi <balbi@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] usb: Use eth_random_addr
Date: Thu, 12 Jul 2012 22:33:11 -0700
Message-Id: <4759c60545463ec0867195792dc5f42f309ed6f0.1342157022.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1341968967.13724.23.camel@joe2Laptop>
References: <1341968967.13724.23.camel@joe2Laptop>
In-Reply-To: <cover.1342157022.git.joe@perches.com>
References: <cover.1342157022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing uses of random_ether_addr to
the new eth_random_addr.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/atm/xusbatm.c    |    4 ++--
 drivers/usb/gadget/u_ether.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
index 14ec9f0..b3b1bb7 100644
--- a/drivers/usb/atm/xusbatm.c
+++ b/drivers/usb/atm/xusbatm.c
@@ -20,7 +20,7 @@
  ******************************************************************************/
 
 #include <linux/module.h>
-#include <linux/etherdevice.h>		/* for random_ether_addr() */
+#include <linux/etherdevice.h>		/* for eth_random_addr() */
 
 #include "usbatm.h"
 
@@ -163,7 +163,7 @@ static int xusbatm_atm_start(struct usbatm_data *usbatm,
 	atm_dbg(usbatm, "%s entered\n", __func__);
 
 	/* use random MAC as we've no way to get it from the device */
-	random_ether_addr(atm_dev->esi);
+	eth_random_addr(atm_dev->esi);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index 47cf48b..b9e1925 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -724,7 +724,7 @@ static int get_ether_addr(const char *str, u8 *dev_addr)
 		if (is_valid_ether_addr(dev_addr))
 			return 0;
 	}
-	random_ether_addr(dev_addr);
+	eth_random_addr(dev_addr);
 	return 1;
 }
 
-- 
1.7.8.111.gad25c.dirty

