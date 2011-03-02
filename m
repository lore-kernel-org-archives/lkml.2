Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1CBAbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:31:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59147 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab1CBAbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:31:09 -0500
Date: Tue, 1 Mar 2011 16:29:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging/brcm80211: fix printk format warnings
Message-Id: <20110301162948.34c28d6e.randy.dunlap@oracle.com>
In-Reply-To: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6D8FC1.0125,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1379: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/staging/brcm80211/sys/wl_mac80211.c:1827: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/staging/brcm80211/sys/wl_mac80211.c:1832: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20110301.orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ linux-next-20110301/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1376,7 +1376,7 @@ wl_cfg80211_connect(struct wiphy *wiphy,
 	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
-	WL_DBG("join_param_size %d\n", join_params_size);
+	WL_DBG("join_param_size %zd\n", join_params_size);
 
 	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
 		WL_DBG("ssid \"%s\", len (%d)\n",
--- linux-next-20110301.orig/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ linux-next-20110301/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1824,12 +1824,12 @@ int wl_check_firmwares(struct wl_info *w
 			WL_ERROR("%s: invalid bin/hdr fw\n", __func__);
 			rc = -EBADF;
 		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
-			WL_ERROR("%s: non integral fw hdr file size %d/%zu\n",
+			WL_ERROR("%s: non integral fw hdr file size %zd/%zu\n",
 				 __func__, fw_hdr->size,
 				 sizeof(struct wl_fw_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			WL_ERROR("%s: out of bounds fw file size %d\n",
+			WL_ERROR("%s: out of bounds fw file size %zd\n",
 				 __func__, fw->size);
 			rc = -EBADF;
 		} else {
