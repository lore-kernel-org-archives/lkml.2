Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0LNA5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:42 -0500
Received: from mail.perches.com ([173.55.12.10]:2631 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0LNA52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:28 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 8/8] staging: brcm80211: Convert ETHER_TYPE_802_1X to ETH_P_PAE
Date: Mon, 13 Dec 2010 16:57:04 -0800
Message-Id: <7206f2d8511a22efa9b165ef7581eb88fa6f6603.1292287726.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove now unused #define.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    4 ++--
 drivers/staging/brcm80211/include/proto/ethernet.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ec6202b..db45083 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1034,7 +1034,7 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 
 		if (is_multicast_ether_addr(eh->ether_dhost))
 			dhdp->tx_multicast++;
-		if (ntoh16(eh->ether_type) == ETHER_TYPE_802_1X)
+		if (ntoh16(eh->ether_type) == ETH_P_PAE)
 			atomic_inc(&dhd->pend_8021x_cnt);
 	}
 
@@ -1262,7 +1262,7 @@ void dhd_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 	eh = (struct ether_header *)(txp->data);
 	type = ntoh16(eh->ether_type);
 
-	if (type == ETHER_TYPE_802_1X)
+	if (type == ETH_P_PAE)
 		atomic_dec(&dhd->pend_8021x_cnt);
 
 }
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index ad55b56..567407d 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -29,7 +29,6 @@
 #define	ETHER_MAX_DATA		1500
 
 #define	ETHER_TYPE_BRCM		0x886c
-#define	ETHER_TYPE_802_1X	0x888e
 
 #define ETHER_DEST_OFFSET	(0 * ETH_ALEN)
 #define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
-- 
1.7.3.3.398.g0b0cd.dirty

