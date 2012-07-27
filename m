Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2G0LkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 07:40:14 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:38960 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2G0LkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 07:40:11 -0400
Date: Fri, 27 Jul 2012 13:40:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] of: drop of_pdt_build_more in pdt.c
Message-ID: <20120727114009.GA5227@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bc1fde5cacff425c4bddc061a72e52d3ecb9eeb2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 27 Jul 2012 13:34:54 +0200
Subject: [PATCH] of: drop of_pdt_build_more in pdt.c

It is no longer used - as the sparc usage was dropped in:
d884297acac228f15a793850be167ba8f9dd3818 -
"sparc32,leon: drop leon_init()"

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/of/pdt.c       |    6 ------
 include/linux/of_pdt.h |    3 ---
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 07cc1d6..fd86ddb 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -26,9 +26,6 @@
 
 static struct of_pdt_ops *of_pdt_prom_ops __initdata;
 
-void __initdata (*of_pdt_build_more)(struct device_node *dp,
-		struct device_node ***nextp);
-
 #if defined(CONFIG_SPARC)
 unsigned int of_pdt_unique_id __initdata;
 
@@ -220,9 +217,6 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 		dp->child = of_pdt_build_tree(dp,
 				of_pdt_prom_ops->getchild(node), nextp);
 
-		if (of_pdt_build_more)
-			of_pdt_build_more(dp, nextp);
-
 		node = of_pdt_prom_ops->getsibling(node);
 	}
 
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
index c65a18a..cb5cf3c 100644
--- a/include/linux/of_pdt.h
+++ b/include/linux/of_pdt.h
@@ -39,7 +39,4 @@ extern void *prom_early_alloc(unsigned long size);
 /* for building the device tree */
 extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
 
-extern void (*of_pdt_build_more)(struct device_node *dp,
-		struct device_node ***nextp);
-
 #endif /* _LINUX_OF_PDT_H */
-- 
1.6.0.6

