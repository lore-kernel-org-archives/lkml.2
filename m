Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1FSKMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:12:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1FSKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u1LnhkSM4jVAfxqYclEGhdNMyMNU9m34GOKLob4L4Z81LYmjqWOpu+z+2lHljvSB6p
         hgFt1hwE/cZeAncseyT5OXzmO4H1gxUXUFnHFPEzfGeFaghDAZSkPEZT0Fe1k4Of8gP5
         ygQFNq1ByKg9d6fuxG8I01yQLrjoHb5MaxOiM=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Dan Carpenter <error27@gmail.com>,
        David Chosrova <dada2372@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 3/3] drivers:rtl8192u:remove the use of obsolete create_workqueue in ieee80211_softmac.c
Date: Sun, 19 Jun 2011 18:11:58 +0800
Message-Id: <1308478318-8462-3-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
References: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of obsolete create_workqueue(name, 0) interface
in ieee80211_softmac.c, since it has changed.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 4ec0a65..d65e5b2 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2726,11 +2726,7 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	ieee->beacon_timer.data = (unsigned long) ieee;
 	ieee->beacon_timer.function = ieee80211_send_beacon_cb;
 
-#ifdef PF_SYNCTHREAD
-	ieee->wq = create_workqueue(DRV_NAME,0);
-#else
 	ieee->wq = create_workqueue(DRV_NAME);
-#endif
 
 	INIT_DELAYED_WORK(&ieee->start_ibss_wq,ieee80211_start_ibss_wq);
 	INIT_WORK(&ieee->associate_complete_wq, ieee80211_associate_complete_wq);
-- 
1.7.4.1

