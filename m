Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0LNA52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:28 -0500
Received: from mail.perches.com ([173.55.12.10]:2622 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab0LNA50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 6/8] staging: brcm80211: Remove ETHER_HDR_LEN, use ETH_HLEN
Date: Mon, 13 Dec 2010 16:57:02 -0800
Message-Id: <b6b82ac96452e2958cc53d8f4b09c5f018625e0b.1292287725.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |    1 -
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index a8638db..888165e 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -23,7 +23,6 @@
 
 #define	ETHER_TYPE_LEN		2
 #define	ETHER_CRC_LEN		4
-#define	ETHER_HDR_LEN		(ETH_ALEN * 2 + ETHER_TYPE_LEN)
 #define	ETHER_MIN_LEN		64
 #define	ETHER_MIN_DATA		46
 #define	ETHER_MAX_LEN		1518
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 407f5ec..8a89b5f 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1727,7 +1727,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 
 	/* some code depends on packed structures */
 	ASSERT(sizeof(struct ether_addr) == ETH_ALEN);
-	ASSERT(sizeof(struct ether_header) == ETHER_HDR_LEN);
+	ASSERT(sizeof(struct ether_header) == ETH_HLEN);
 	ASSERT(sizeof(d11regs_t) == SI_CORE_SIZE);
 	ASSERT(sizeof(ofdm_phy_hdr_t) == D11_PHY_HDR_LEN);
 	ASSERT(sizeof(cck_phy_hdr_t) == D11_PHY_HDR_LEN);
-- 
1.7.3.3.398.g0b0cd.dirty

