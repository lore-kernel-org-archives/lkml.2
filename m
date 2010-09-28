Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0I1RIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:08:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51574 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab0I1RID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wBEP0vWkJKYhPM5Y8SQN1qeJ8q+7wYZxPPcP3bj4RByawH50dBr+L5ODo9Ta9V4Yyd
         3hOiHTqNmh/0nNlef8mmD3DGuPsHBh6Pkg4zc0Er/eUuedTxVXIWuJMyOx3v/Eq5KFO9
         CsZ4CODUVXhqlsUlOz0D7z8GlWQqIeeF2ioA8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vipin Mehta <vmehta@atheros.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] staging: ath6kl: use free_netdev(netdev) instead of kfree()
Date: Tue, 28 Sep 2010 21:07:55 +0400
Message-Id: <1285693675-4637-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not guaranteed that free_netdev() is macro.
Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.


Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index daba6e4..c5a6d6c 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2143,11 +2143,7 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
         unregister_netdev(dev);
         is_netdev_registered = 0;
     }
-#ifndef free_netdev
-    kfree(dev);
-#else
     free_netdev(dev);
-#endif
 
 #ifdef ATH6K_CONFIG_CFG80211
     ar6k_cfg80211_deinit(ar);
@@ -6429,11 +6425,7 @@ A_STATUS ar6000_remove_ap_interface(AR_SOFTC_T *ar)
         ar6000_stop_ap_interface(ar);
 
         unregister_netdev(arApNetDev);
-#ifndef free_netdev
-        kfree(arApNetDev);
-#else
         free_netdev(apApNetDev);
-#endif
 
         A_PRINTF("Remove AP interface\n");
     }
-- 
1.7.0.4

