Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0DIWde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:33:34 -0400
Received: from mga10.intel.com ([192.55.52.92]:63460 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752364Ab0DIWdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,179,1270450800"; 
   d="scan'208";a="787931577"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/3] rtl8187se: Do not mess with carrier settings while scanning
Date: Sat, 10 Apr 2010 00:33:18 +0200
Message-Id: <74e7fb46ccc6f91492263a69b0f736a10823a763.1270851261.git.sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
References: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
In-Reply-To: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
References: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toggling the link carrier is a non sense and is the grossest locking I can
think of. Moreover, it's giving a completely inaccurate status to userspace
who could for example decide to turn the interface down on carrier off
detection.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index ad42bcd..e46ff2f 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -277,8 +277,6 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 
 	chan = ieee->current_network.channel;
 
-	netif_carrier_off(ieee->dev);
-
 	if (ieee->data_hard_stop)
 		ieee->data_hard_stop(ieee->dev);
 
@@ -300,8 +298,6 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 	if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
 		ieee80211_start_send_beacons(ieee);
 
-	netif_carrier_on(ieee->dev);
-
 	//YJ,add,080828, In prevent of lossing ping packet during scanning
 	//ieee80211_sta_ps_send_null_frame(ieee, false);
 	//YJ,add,080828,end
-- 
1.7.0

