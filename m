Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0F1L4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:56:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab0F1Lzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Wxxqhctwk+LUKChD3zNdxtu28k33NyrqijdCEh0d8leaYt3LNg9Jp8+f+PiPkVwYuP
         GutDaiiDczvMHyqJQX95WMsE1aMw+DHmomBZgG7GNCY/A+aBLIh2yGF+kKuWViRhcb73
         c7IEqCMTHDHaYvxT9ZinF/Kc+m58HvqKGKyiA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Kulikov Vasiliy <segooon@gmail.com>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:28 +0400
Message-Id: <1277726130-24798-1-git-send-email-segooon@gmail.com>
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
index 4971b1c..068cc06 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -121,7 +121,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
         }
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
-	for(i=0; i<(sizeof(ieee80211_modes)/sizeof(ieee80211_modes[0])); i++) {
+	for(i=0; i<ARRAY_SIZE(ieee80211_modes); i++) {
 		if(network->mode&(1<<i)) {
 			sprintf(pname,ieee80211_modes[i].mode_string,ieee80211_modes[i].mode_size);
 			pname +=ieee80211_modes[i].mode_size;
-- 
1.7.0.4

