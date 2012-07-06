Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2GFP3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:29:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:43256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab2GFP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174187131"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Chan <benchan@chromium.org>
Subject: [PATCH 3/6] staging: gdm72xx: use %pM for MAC
Date: Fri,  6 Jul 2012 18:28:15 +0300
Message-Id: <1341588498-21689-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_wimax.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 110bdbc..e616de1 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -744,13 +744,8 @@ static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
 					"[%x/%d]\n", __func__, T, L);
 				return -1;
 			}
-			printk(KERN_INFO
-				"MAC change [%02x:%02x:%02x:%02x:%02x:%02x]"
-				"->[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-				dev->dev_addr[0], dev->dev_addr[1],
-				dev->dev_addr[2], dev->dev_addr[3],
-				dev->dev_addr[4], dev->dev_addr[5],
-				V[0], V[1], V[2], V[3], V[4], V[5]);
+			printk(KERN_INFO "MAC change [%pM]->[%pM]\n",
+				dev->dev_addr, V);
 			memcpy(dev->dev_addr, V, dev->addr_len);
 			return 1;
 		}
-- 
1.7.10.4

