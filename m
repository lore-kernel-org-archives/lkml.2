Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451Ab2KARnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:43:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:39218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2KARna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:43:30 -0400
Message-ID: <5092B4BE.4080803@infradead.org>
Date: Thu, 01 Nov 2012 10:43:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH -next] wireless: brcmfmac: fix printk format warning
References: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>
In-Reply-To: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix printk format warning for ssid_len, which is a size_t:

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3941:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	brcm80211-dev-list@broadcom.com
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121101.orig/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ linux-next-20121101/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3938,7 +3938,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wi
 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
 		 settings->channel_type, settings->beacon_interval,
 		 settings->dtim_period);
-	WL_TRACE("ssid=%s(%d), auth_type=%d, inactivity_timeout=%d\n",
+	WL_TRACE("ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
 		 settings->ssid, settings->ssid_len, settings->auth_type,
 		 settings->inactivity_timeout);
 
