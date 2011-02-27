Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1B0Eg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:36:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1B0Eek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RbQXsmaUEOVc+hhaOe6i6YH0jamUlrqYFMgt6mV5B1S0215qGWMfieGdvU6rr2p13M
         VrE3qhh5QAPNI3k25ySyzl4vrzcwAs122I7xFkvYR9KCA+bwL5uUL0Esc4BfrFXVb4L9
         j4p1Zt1xRLFw5Z1MRu/X495eYqq3yO9fizWAg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Jesper Juhl <jj@chaosbits.net>, devel@driverdev.osuosl.org
Subject: [PATCH 06/17]drivers:staging:rt2860 Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:59 -0800
Message-Id: <1298781250-2718-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
CC: Jesper Juhl <jj@chaosbits.net>
CC: devel@driverdev.osuosl.org 
---
 drivers/staging/rt2860/common/ba_action.c |    2 +-
 drivers/staging/rt2860/common/cmm_data.c  |    2 +-
 drivers/staging/rt2860/rtmp.h             |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index b046c2b..62f6f6b 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -107,7 +107,7 @@ void Announce_Reordering_Packet(struct rt_rtmp_adapter *pAd,
 
 	if (mpdu->bAMSDU) {
 		ASSERT(0);
-		BA_Reorder_AMSDU_Annnounce(pAd, pPacket);
+		BA_Reorder_AMSDU_Announce(pAd, pPacket);
 	} else {
 		/* */
 		/* pass this 802.3 packet to upper layer or forward this packet to WM directly */
diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
index 2204c2b..f6c193c 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1481,7 +1481,7 @@ u32 deaggregate_AMSDU_announce(struct rt_rtmp_adapter *pAd,
 	return nMSDU;
 }
 
-u32 BA_Reorder_AMSDU_Annnounce(struct rt_rtmp_adapter *pAd, void *pPacket)
+u32 BA_Reorder_AMSDU_Announce(struct rt_rtmp_adapter *pAd, void *pPacket)
 {
 	u8 *pData;
 	u16 DataSize;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 70daaa4..d16b06a 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3611,7 +3611,7 @@ struct rt_rtmp_sg_list *rt_get_sg_list_from_packet(void *pPacket,
 
 void announce_802_3_packet(struct rt_rtmp_adapter *pAd, void *pPacket);
 
-u32 BA_Reorder_AMSDU_Annnounce(struct rt_rtmp_adapter *pAd, void *pPacket);
+u32 BA_Reorder_AMSDU_Announce(struct rt_rtmp_adapter *pAd, void *pPacket);
 
 struct net_device *get_netdev_from_bssid(struct rt_rtmp_adapter *pAd, u8 FromWhichBSSID);
 
-- 
1.7.4.1

