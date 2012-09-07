Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2IGUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:09:59 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22361
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab2IGUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:09:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h1155h)
From: Timur Tabi <timur@freescale.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
        <rdunlap@xenotime.net>
Subject: [PATCH] netdev/phy: mdio-mux-mmioreg.c should include of_address.h
Date: Fri, 7 Sep 2012 15:09:52 -0500
Message-ID: <1347048592-22957-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
Organization: Freescale Semiconductor
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mdio-mux-mmioreg.c uses function of_address_to_resource(), which is defined
in linux/of_address.h.  This fixes a compilation error:

drivers/net/phy/mdio-mux-mmioreg.c: In function 'mdio_mux_mmioreg_probe':
drivers/net/phy/mdio-mux-mmioreg.c:83:2: error: implicit declaration of
	function 'of_address_to_resource'

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/net/phy/mdio-mux-mmioreg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/mdio-mux-mmioreg.c b/drivers/net/phy/mdio-mux-mmioreg.c
index 098239a..9061ba6 100644
--- a/drivers/net/phy/mdio-mux-mmioreg.c
+++ b/drivers/net/phy/mdio-mux-mmioreg.c
@@ -12,6 +12,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/device.h>
+#include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/module.h>
 #include <linux/init.h>
-- 
1.7.3.4


