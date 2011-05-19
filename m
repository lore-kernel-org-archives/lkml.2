Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab1ESSSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:18:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37084 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933928Ab1ESSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:36 -0400
X-Sasl-enc: 1qjIOhtAStVRqtYPJgM2agEnQOrJnhJRW2toRfqOFeYw 1305828515
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.553842521@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [34/71] PCH_GbE : Fixed the issue of collision detection
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit ce3dad0f74e6b240f0b1dedbd8ea268a3f298d82 upstream.

The collision detection setting was invalid.
When collision occurred, because data was not resent,
there was an issue to which a transmitting throughput falls.

This patch enables the collision detection.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pch_gbe/pch_gbe_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -43,8 +43,7 @@ const char pch_driver_version[] = DRV_VE
 
 #define PCH_GBE_MAC_RGMII_CTRL_SETTING ( \
 	PCH_GBE_CHIP_TYPE_INTERNAL | \
-	PCH_GBE_RGMII_MODE_RGMII   | \
-	PCH_GBE_CRS_SEL              \
+	PCH_GBE_RGMII_MODE_RGMII     \
 	)
 
 /* Ethertype field values */


