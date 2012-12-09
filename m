Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2LILEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:04:34 -0500
Received: from wren.arvixe.com ([50.97.138.99]:57557 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357Ab2LILEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:04:32 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 4/5] rtl8712: replace min with min_t
Date: Sun,  9 Dec 2012 10:15:09 +0000
Message-Id: <1355048110-10859-4-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A clean up change suggested by checkpatch.pl

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index cdb51d7..b131b61 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -188,8 +188,7 @@ static inline char *translate_scan(struct _adapter *padapter,
 	/* Add the ESSID */
 	iwe.cmd = SIOCGIWESSID;
 	iwe.u.data.flags = 1;
-	iwe.u.data.length = (u16)min((u16)pnetwork->network.Ssid.SsidLength,
-			    (u16)32);
+	iwe.u.data.length = min_t(u16, pnetwork->network.Ssid.SsidLength, 32);
 	start = iwe_stream_add_point(info, start, stop, &iwe,
 				     pnetwork->network.Ssid.Ssid);
 	/* parsing HT_CAP_IE */
@@ -1193,8 +1192,7 @@ static int r8711_wx_set_scan(struct net_device *dev,
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 			struct ndis_802_11_ssid ssid;
 			unsigned long irqL;
-			u32 len = (u32) min((u8)req->essid_len,
-				  (u8)IW_ESSID_MAX_SIZE);
+			u32 len = min_t(u8, req->essid_len, IW_ESSID_MAX_SIZE);
 			memset((unsigned char *)&ssid, 0,
 				 sizeof(struct ndis_802_11_ssid));
 			memcpy(ssid.Ssid, req->essid, len);
-- 
1.8.0.1

