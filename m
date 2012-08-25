Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2HYBjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:39:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46123 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2HYBjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:39:16 -0400
MIME-Version: 1.0
Date: Sat, 25 Aug 2012 09:39:15 +0800
Message-ID: <CAPgLHd_nqA0eQnosUiWkxh+aZJofYMFCrE07qsbDEgg_x1BoSQ@mail.gmail.com>
Subject: [PATCH] staging: csr: use is_zero_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is all
zeros.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/csr/sme_wext.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/csr/sme_wext.c b/drivers/staging/csr/sme_wext.c
index 7e85907..f09a738 100644
--- a/drivers/staging/csr/sme_wext.c
+++ b/drivers/staging/csr/sme_wext.c
@@ -1191,8 +1191,6 @@ unifi_siwap(struct net_device *dev, struct iw_request_info *info,
     netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(dev);
     unifi_priv_t *priv = interfacePriv->privPtr;
     int err = 0;
-    const unsigned char zero_bssid[ETH_ALEN] = {0x00, 0x00, 0x00,
-        0x00, 0x00, 0x00};
 
     func_enter();
 
@@ -1213,7 +1211,7 @@ unifi_siwap(struct net_device *dev, struct iw_request_info *info,
 	unifi_trace(priv, UDBG1, "unifi_siwap: asked for %pM\n",
 		wrqu->ap_addr.sa_data);
 
-    if (!memcmp(wrqu->ap_addr.sa_data, zero_bssid, ETH_ALEN)) {
+    if (is_zero_ether_addr(wrqu->ap_addr.sa_data)) {
         priv->ignore_bssid_join = FALSE;
         err = sme_mgt_disconnect(priv);
         if (err) {


