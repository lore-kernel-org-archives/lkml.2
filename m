Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2LEB3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:29:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55873 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2LEB3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:29:18 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, jim.cromie@gmail.com,
        marcos.souza.org@gmail.com, devel@driverdev.osuosl.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] staging: rtl8712: avoid a useless call to memset().
Date: Wed,  5 Dec 2012 02:22:02 +0100
Message-Id: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
has just been zeroed by a call to memset().

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 3a64790..2c73319 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1131,10 +1131,11 @@ static int r8711_wx_get_wap(struct net_device *dev,
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 
 	wrqu->ap_addr.sa_family = ARPHRD_ETHER;
-	memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
 	if (check_fwstate(pmlmepriv, _FW_LINKED |
 	    WIFI_ADHOC_MASTER_STATE|WIFI_AP_STATE)) {
 		memcpy(wrqu->ap_addr.sa_data, pcur_bss->MacAddress, ETH_ALEN);
+	} else {
+		memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
 	}
 	return 0;
 }
-- 
1.7.10.4

