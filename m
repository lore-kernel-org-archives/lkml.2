Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0GALXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:23:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0GALXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uMAOK2x/YOZjKS92xIR216MK48fyRU1lSdwtvjaTCXxBmvWGWO3XpBvIA8GrdDqxGx
         jupis5oGjTL1PJBZO6U6eUZ2AO+yXRh5REYBERoVnwkRURhPrnyQp1UDHaoLndn3lSsV
         0f56cXgtOvJPrXu19s2SRKqRqXJZ5VTYm4cCA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Tejun Heo <tj@kernel.org>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] staging/rtl8192e/ieee80211: use ARRAY_SIZE
Date: Thu,  1 Jul 2010 15:23:04 +0400
Message-Id: <1277983385-29458-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index 4971b1c..6dcaac5 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -121,7 +121,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
         }
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
-	for(i=0; i<(sizeof(ieee80211_modes)/sizeof(ieee80211_modes[0])); i++) {
+	for (i = 0; i < ARRAY_SIZE(ieee80211_modes); i++) {
 		if(network->mode&(1<<i)) {
 			sprintf(pname,ieee80211_modes[i].mode_string,ieee80211_modes[i].mode_size);
 			pname +=ieee80211_modes[i].mode_size;
-- 
1.7.0.4

