Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2LDUP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:15:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33856 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2LDUPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:15:53 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, pe1dnn@amsat.org,
        gregkh@linuxfoundation.org, jkosina@suse.cz,
        yongjun_wei@trendmicro.com.cn, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] staging: wlags49_h2: remove unneeded memset() in wireless_get_bssid()
Date: Tue,  4 Dec 2012 21:08:36 +0100
Message-Id: <1354651717-27888-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few lines after this call, we memcpy over the same memory area, so the call to
memset is not necessary.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index f553366..c731ff2 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -796,8 +796,6 @@ static int wireless_get_bssid(struct net_device *dev, struct iw_request_info *in
 
     	wl_act_int_off( lp );
 
-	memset( &ap_addr->sa_data, 0, ETH_ALEN );
-
 	ap_addr->sa_family = ARPHRD_ETHER;
 
 	/* Assume AP mode here, which means the BSSID is our own MAC address. In
-- 
1.7.10.4

