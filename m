Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2JKCN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:13:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54654 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933030Ab2JKCNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:13:23 -0400
X-Sasl-enc: /B8RhGLwhKpp7tsRy/2tpKJBSVBivk1cRYLAcZ1vPZxb 1349921602
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/84] ixp4xx_hss: fix build failure due to missing linux/module.h inclusion
Date: Thu, 11 Oct 2012 11:03:05 +0900
Message-Id: <20121011015420.886151219@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Florian Fainelli <florian@openwrt.org>

[ Upstream commit 0b836ddde177bdd5790ade83772860940bd481ea ]

Commit 36a1211970193ce215de50ed1e4e1272bc814df1 (netprio_cgroup.h:
dont include module.h from other includes) made the following build
error on ixp4xx_hss pop up:

  CC [M]  drivers/net/wan/ixp4xx_hss.o
 drivers/net/wan/ixp4xx_hss.c:1412:20: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1413:25: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1414:21: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1415:19: error: expected ';', ',' or ')'
 before string constant
 make[8]: *** [drivers/net/wan/ixp4xx_hss.o] Error 1

This was previously hidden because ixp4xx_hss includes linux/hdlc.h which
includes linux/netdevice.h which includes linux/netprio_cgroup.h which
used to include linux/module.h. The real issue was actually present since
the initial commit that added this driver since it uses macros from
linux/module.h without including this file.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/ixp4xx_hss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>


