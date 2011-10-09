Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1JILM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35341 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1JILMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:12:07 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 7/7] staging: wlags49_h2: Fixup SIOCSIWGENIE
Date: Sun,  9 Oct 2011 12:11:37 +0100
Message-Id: <1318158697-15979-8-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the key management scheme is done in SIOCSIWAUTH, so
no need to do anything in SIOCSIWGENIE.

Fix up function name.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   40 +++++++--------------------------
 1 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 9884320..8ac5e10 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -3196,42 +3196,20 @@ out:
 
 
 
-static int wireless_get_genie(struct net_device *dev,
-					   struct iw_request_info *info,
-					   struct iw_point *data, char *extra)
+static int wireless_set_genie(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *data, char *extra)
 
 {
-	struct wl_private *lp = wl_priv(dev);
-	unsigned long flags;
 	int   ret = 0;
-	ltv_t ltv;
-
-	DBG_FUNC( "wireless_get_genie" );
-	DBG_ENTER( DbgInfo );
-
-	if(lp->portState == WVLAN_PORT_STATE_DISABLED) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	wl_lock( lp, &flags );
 
-    	wl_act_int_off( lp );
-
-	memset(&ltv, 0, sizeof(ltv));
-	ltv.len = 2;
-	ltv.typ = CFG_SET_WPA_AUTH_KEY_MGMT_SUITE;
-	lp->AuthKeyMgmtSuite = ltv.u.u16[0] = 4;
-	ltv.u.u16[0]  = CNV_INT_TO_LITTLE(ltv.u.u16[0]);
-
-	ret = hcf_put_info(&(lp->hcfCtx), (LTVP)&ltv);
-
-    	wl_act_int_on( lp );
+	DBG_ENTER(DbgInfo);
 
-	wl_unlock(lp, &flags);
+	/* We can't write this to the card, but apparently this
+	 * operation needs to succeed */
+	ret = 0;
 
-out:
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ret;
 }
 /*============================================================================*/
@@ -3970,7 +3948,7 @@ static const iw_handler wl_handler[] =
 	IW_HANDLER(SIOCGIWENCODE, (iw_handler) wireless_get_encode),
 	IW_HANDLER(SIOCSIWPOWER, (iw_handler) wireless_set_power),
 	IW_HANDLER(SIOCGIWPOWER, (iw_handler) wireless_get_power),
-	IW_HANDLER(SIOCSIWGENIE, (iw_handler) wireless_get_genie),
+	IW_HANDLER(SIOCSIWGENIE, (iw_handler) wireless_set_genie),
 	IW_HANDLER(SIOCSIWAUTH, (iw_handler) wireless_set_auth),
 	IW_HANDLER(SIOCSIWENCODEEXT, (iw_handler) wireless_set_encodeext),
 };
-- 
1.7.4.1

