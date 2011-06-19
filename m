Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1FSKMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:12:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47507 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1FSKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pFecvkEi2oAX6loDFsjLTyuaJWZ/Jfcq0SaSXaISbdPUTejMzm9NckO32BgA1DlWtL
         FP2c08LzYm8Q6RBhQh5yThdNEV5uFWWIQIUeUxUnZuSZ/TGBwloEN+18M0wHBgK6/kVd
         ue2y0CxIqLphw2LPfNah5NNcn1ZW24y13pa/E=
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
Subject: [PATCH 1/3] drivers:rtl8187se:remove the use of obsolete create_workqueue in ieee80211_softmac.c
Date: Sun, 19 Jun 2011 18:11:56 +0800
Message-Id: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of obsolete create_workqueue(name, 0) in
ieee80211_softmac.c, since the create_workqueue interface has changed.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 736a140..8925989 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -2568,11 +2568,8 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	ieee->beacon_timer.data = (unsigned long) ieee;
 	ieee->beacon_timer.function = ieee80211_send_beacon_cb;
 
-#ifdef PF_SYNCTHREAD
-	ieee->wq = create_workqueue(DRV_NAME,0);
-#else
 	ieee->wq = create_workqueue(DRV_NAME);
-#endif
+
 	INIT_DELAYED_WORK(&ieee->start_ibss_wq,(void*) ieee80211_start_ibss_wq);
 	INIT_WORK(&ieee->associate_complete_wq,(void*) ieee80211_associate_complete_wq);
 	INIT_WORK(&ieee->associate_procedure_wq,(void*) ieee80211_associate_procedure_wq);
-- 
1.7.4.1

