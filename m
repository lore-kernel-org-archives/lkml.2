Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1KFXQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:16:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17216 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1KFXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:16:08 -0500
Date: Mon, 7 Nov 2011 00:21:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
cc: Andrea Merello <andreamrl@tiscali.it>, Mike McCormack <mikem@ring3k.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: [PATCH] rtl8192e: Don't copy huge struct by value (and make it
 const).
Message-ID: <alpine.LNX.2.00.1111070017220.5763@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtllib_is_shortslot() takes one argument - a struct that's more than a
kilobyte large. It should take a pointer instead of copying such a
huge struct - and the argument might as well be declared 'const' now
that we are at it, since it is not modified. This patch makes these
changes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/rtl8192e/rtllib.h         |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index de25975..3a52120 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2804,7 +2804,7 @@ extern int rtllib_wx_set_gen_ie(struct rtllib_device *ieee, u8 *ie, size_t len);
 
 /* rtllib_softmac.c */
 extern short rtllib_is_54g(struct rtllib_network *net);
-extern short rtllib_is_shortslot(struct rtllib_network net);
+extern short rtllib_is_shortslot(const struct rtllib_network *net);
 extern int rtllib_rx_frame_softmac(struct rtllib_device *ieee,
 				   struct sk_buff *skb,
 				   struct rtllib_rx_stats *rx_stats, u16 type,
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index b508685..fa774cf 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -28,9 +28,9 @@ short rtllib_is_54g(struct rtllib_network *net)
 	return (net->rates_ex_len > 0) || (net->rates_len > 4);
 }
 
-short rtllib_is_shortslot(struct rtllib_network net)
+short rtllib_is_shortslot(const struct rtllib_network *net)
 {
-	return net.capability & WLAN_CAPABILITY_SHORT_SLOT_TIME;
+	return net->capability & WLAN_CAPABILITY_SHORT_SLOT_TIME;
 }
 
 /* returns the total length needed for pleacing the RATE MFIE
-- 
1.7.7.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

