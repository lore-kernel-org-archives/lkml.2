Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2B2Pop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:44:45 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38784 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308Ab2B2PnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:43:14 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] cris/eth_v10: use dev_set_mac_address() instead of e100_set_mac_address()
Date: Wed, 29 Feb 2012 16:42:51 +0100
Message-Id: <1330530176-24952-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330530194;78b5cb18;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_set_mac_address() instead of e100_set_mac_address() directly
to get validation checks for free.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/cris/eth_v10.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7cb2785..ce6f3e6 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -377,8 +377,7 @@ etrax_ethernet_init(void)
 	}
 
 	/* set the default MAC address */
-
-	e100_set_mac_address(dev, &default_mac);
+	dev_set_mac_address(dev, &default_mac);
 
 	/* Initialize speed indicator stuff. */
 
-- 
1.7.8.3

