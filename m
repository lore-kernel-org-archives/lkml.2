Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0KHXVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:39387 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0KHXV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:29 -0500
Date: Tue, 9 Nov 2010 00:10:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 11/17][trivial] staging, brcm80211: Remove unnecessary casts
 of void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082346040.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/staging/brcm80211/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 wl_cfg80211.c |   23 +++++++++++------------
 wl_iw.c       |    7 ++-----
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3f29488..0011521 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -705,7 +705,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 
 	if (ssid && ssid->SSID_len)
 		params_size += sizeof(struct wlc_ssid);
-	params = (struct wl_iscan_params *)kzalloc(params_size, GFP_KERNEL);
+	params = kzalloc(params_size, GFP_KERNEL);
 	if (unlikely(!params))
 		return -ENOMEM;
 	memset(params, 0, params_size);
@@ -2794,53 +2794,52 @@ static void wl_init_eloop_handler(struct wl_event_loop *el)
 
 static s32 wl_init_priv_mem(struct wl_priv *wl)
 {
-	wl->scan_results = (void *)kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
+	wl->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
 	if (unlikely(!wl->scan_results)) {
 		WL_ERR(("Scan results alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->conf = (void *)kzalloc(sizeof(*wl->conf), GFP_KERNEL);
+	wl->conf = kzalloc(sizeof(*wl->conf), GFP_KERNEL);
 	if (unlikely(!wl->conf)) {
 		WL_ERR(("wl_conf alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->profile = (void *)kzalloc(sizeof(*wl->profile), GFP_KERNEL);
+	wl->profile = kzalloc(sizeof(*wl->profile), GFP_KERNEL);
 	if (unlikely(!wl->profile)) {
 		WL_ERR(("wl_profile alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->bss_info = (void *)kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	wl->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (unlikely(!wl->bss_info)) {
 		WL_ERR(("Bss information alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->scan_req_int =
-	    (void *)kzalloc(sizeof(*wl->scan_req_int), GFP_KERNEL);
+	wl->scan_req_int = kzalloc(sizeof(*wl->scan_req_int), GFP_KERNEL);
 	if (unlikely(!wl->scan_req_int)) {
 		WL_ERR(("Scan req alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->ioctl_buf = (void *)kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
+	wl->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
 	if (unlikely(!wl->ioctl_buf)) {
 		WL_ERR(("Ioctl buf alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->extra_buf = (void *)kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
+	wl->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (unlikely(!wl->extra_buf)) {
 		WL_ERR(("Extra buf alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->iscan = (void *)kzalloc(sizeof(*wl->iscan), GFP_KERNEL);
+	wl->iscan = kzalloc(sizeof(*wl->iscan), GFP_KERNEL);
 	if (unlikely(!wl->iscan)) {
 		WL_ERR(("Iscan buf alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->fw = (void *)kzalloc(sizeof(*wl->fw), GFP_KERNEL);
+	wl->fw = kzalloc(sizeof(*wl->fw), GFP_KERNEL);
 	if (unlikely(!wl->fw)) {
 		WL_ERR(("fw object alloc failed\n"));
 		goto init_priv_mem_out;
 	}
-	wl->pmk_list = (void *)kzalloc(sizeof(*wl->pmk_list), GFP_KERNEL);
+	wl->pmk_list = kzalloc(sizeof(*wl->pmk_list), GFP_KERNEL);
 	if (unlikely(!wl->pmk_list)) {
 		WL_ERR(("pmk list alloc failed\n"));
 		goto init_priv_mem_out;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 979a494..97beae0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -3690,8 +3690,7 @@ int wl_iw_attach(struct net_device *dev, void *dhdp)
 		return -ENOMEM;
 	memset(iscan, 0, sizeof(iscan_info_t));
 
-	iscan->iscan_ex_params_p =
-	    (wl_iscan_params_t *) kmalloc(params_size, GFP_KERNEL);
+	iscan->iscan_ex_params_p = kmalloc(params_size, GFP_KERNEL);
 	if (!iscan->iscan_ex_params_p)
 		return -ENOMEM;
 	iscan->iscan_ex_param_size = params_size;
@@ -3723,9 +3722,7 @@ int wl_iw_attach(struct net_device *dev, void *dhdp)
 	priv_dev = dev;
 	MUTEX_LOCK_SOFTAP_SET_INIT(iw->pub);
 #endif
-	g_scan = NULL;
-
-	g_scan = (void *)kmalloc(G_SCAN_RESULTS, GFP_KERNEL);
+	g_scan = kmalloc(G_SCAN_RESULTS, GFP_KERNEL);
 	if (!g_scan)
 		return -ENOMEM;
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

