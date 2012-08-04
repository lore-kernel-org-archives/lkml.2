Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2HDQvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:51:06 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:47135
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab2HDQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:51:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152439854"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] drivers/net/phy/mdio-mux-gpio.c: drop devm_kfree of devm_kzalloc'd data
Date: Sat,  4 Aug 2012 18:50:49 +0200
Message-Id: <1344099049-15212-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kfree should not have to be explicitly used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/phy/mdio-mux-gpio.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/phy/mdio-mux-gpio.c
index e0cc4ef..eefe49e 100644
--- a/drivers/net/phy/mdio-mux-gpio.c
+++ b/drivers/net/phy/mdio-mux-gpio.c
@@ -101,7 +101,6 @@ err:
 		n--;
 		gpio_free(s->gpio[n]);
 	}
-	devm_kfree(&pdev->dev, s);
 	return r;
 }
 

