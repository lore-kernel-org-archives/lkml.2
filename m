Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0CYFTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:19:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1094 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0CYFRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 07/13] drivers/staging/rtl8187se: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:01 -0700
Message-Id: <65ce2b5aaf76237feec33b4dde5e553beb9ad03c.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    3 ++-
 drivers/staging/rtl8187se/r8180_core.c             |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index c2f472e..1f858f8 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1554,7 +1554,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
 	//IEEE80211DMESG("Rx probe");
 	ieee->softmac_stats.rx_auth_rq++;
 
-	if ((status = auth_rq_parse(skb, dest))!= -1){
+	status = auth_rq_parse(skb, dest);
+	if (status!= -1) {
 		ieee80211_resp_to_auth(ieee, status, dest);
 	}
 	//DMESG("Dest is "MACSTR, MAC2STR(dest));
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index b1757ac..4fb2c05 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -402,7 +402,8 @@ short buffer_add(struct buffer **buffer, u32 *buf, dma_addr_t dma,
 	tmp=*buffer;
 
 	while(tmp->next!=(*buffer)) tmp=tmp->next;
-	if ((tmp->next= kmalloc(sizeof(struct buffer),GFP_KERNEL)) == NULL){
+	tmp->next = kmalloc(sizeof(struct buffer),GFP_KERNEL);
+	if (tmp->next == NULL) {
 		DMESGE("Failed to kmalloc TX/RX struct");
 		return -1;
 	}
@@ -1154,7 +1155,8 @@ short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
 	tmp=desc;
 
 	for (i = 0; i < count; i++) {
-		if ((buf= kmalloc(bufsize * sizeof(u8),GFP_ATOMIC)) == NULL){
+		buf = kmalloc(bufsize * sizeof(u8),GFP_ATOMIC);
+		if (buf == NULL) {
 			DMESGE("Failed to kmalloc RX buffer");
 			return -1;
 		}
-- 
1.7.0.14.g7e948

