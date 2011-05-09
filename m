Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1EITwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:52:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1406 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab1EITv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:51:59 -0400
Subject: [PATCH V3] rtlwifi: rtl8192cu: Fix memset/memcpy using sizeof(ptr)
 not sizeof(*ptr)
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DC84071.4080500@lwfinger.net>
References: <1304919832.19586.15.camel@Joe-Laptop>
	 <4DC81009.5060501@lwfinger.net> <1304960976.19586.51.camel@Joe-Laptop>
	 <4DC84071.4080500@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 12:51:57 -0700
Message-ID: <1304970717.19586.74.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found via coccinelle script

@@
type T;
T* ptr;
expression E1;
@@
* memset(E1, 0, sizeof(ptr));

Signed-off-by: Joe Perches <joe@perches.com>

---

 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 79c98f6..3a92ba3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -372,7 +372,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	__le16 fc;
 	struct ieee80211_hdr *hdr;
 
-	memset(rx_status, 0, sizeof(rx_status));
+	memset(rx_status, 0, sizeof(*rx_status));
 	rxdesc	= skb->data;
 	skb_len	= skb->len;
 	drvinfo_len = (GET_RX_DESC_DRVINFO_SIZE(rxdesc) * RTL_RX_DRV_INFO_UNIT);
@@ -434,7 +434,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 		 "0x%02X\n", fc, (u32)hdr->addr1[0], (u32)hdr->addr1[1],
 		 (u32)hdr->addr1[2], (u32)hdr->addr1[3], (u32)hdr->addr1[4],
 		 (u32)hdr->addr1[5]));
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
 	ieee80211_rx_irqsafe(hw, skb);
 }
 


