Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1AZSXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:23:42 -0500
Received: from [123.122.106.155] ([123.122.106.155]:43811 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435Ab1AZSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:23:41 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 13:23:41 EST
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH 5/6] wl_cfg80211.c: use BUG_ON correctly
Date: Thu, 27 Jan 2011 02:39:52 +0800
Message-Id: <1296067193-15879-6-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes explicit unlikely() when using BUG_ON() in
wl_cfg80211.c

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 991463f..35124b1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -673,7 +673,7 @@ wl_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 	s32 iolen;
 
 	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
-	BUG_ON(unlikely(!iolen));
+	BUG_ON(!iolen);
 
 	return wl_dev_ioctl(dev, WLC_SET_VAR, bufptr, iolen);
 }
@@ -685,7 +685,7 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 	s32 iolen;
 
 	iolen = bcm_mkiovar(iovar, param, paramlen, bufptr, buflen);
-	BUG_ON(unlikely(!iolen));
+	BUG_ON(!iolen);
 
 	return wl_dev_ioctl(dev, WLC_GET_VAR, bufptr, buflen);
 }
@@ -704,7 +704,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 	if (unlikely(!params))
 		return -ENOMEM;
 	memset(params, 0, params_size);
-	BUG_ON(unlikely(params_size >= WLC_IOCTL_SMLEN));
+	BUG_ON(params_size >= WLC_IOCTL_SMLEN);
 
 	wl_iscan_prep(&params->params, ssid);
 
@@ -875,7 +875,7 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 
 	val = htod32(val);
 	len = bcm_mkiovar(name, (char *)(&val), sizeof(val), buf, sizeof(buf));
-	BUG_ON(unlikely(!len));
+	BUG_ON(!len);
 
 	err = wl_dev_ioctl(dev, WLC_SET_VAR, buf, len);
 	if (unlikely(err)) {
@@ -899,7 +899,7 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	len =
 	    bcm_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
-	BUG_ON(unlikely(!len));
+	BUG_ON(!len);
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, &var, len);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -2436,7 +2436,7 @@ wl_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 	u32 buflen;
 
 	buflen = bcm_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
-	BUG_ON(unlikely(!buflen));
+	BUG_ON(!buflen);
 
 	return wl_dev_ioctl(dev, WLC_SET_VAR, wl->ioctl_buf, buflen);
 }
@@ -2450,7 +2450,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 	s32 err = 0;
 
 	len = bcm_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
-	BUG_ON(unlikely(!len));
+	BUG_ON(!len);
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, (void *)wl->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
 	if (unlikely(err)) {
-- 
1.7.3.2

