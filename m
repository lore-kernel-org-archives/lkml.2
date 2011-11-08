Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1KHTUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:20:20 -0500
Received: from www17.your-server.de ([213.133.104.17]:58097 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1KHTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:20:18 -0500
Subject: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:18:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320779913.8062.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
--- a/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-07 19:38:11.780313813 +0100
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-08 09:40:07.649215930 +0100
@@ -3048,10 +3048,9 @@ void rtllib_softmac_init(struct rtllib_d
 	ieee->state = RTLLIB_NOLINK;
 	for (i = 0; i < 5; i++)
 		ieee->seq_ctrl[i] = 0;
-	ieee->pDot11dInfo = kmalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
+	ieee->pDot11dInfo = kzalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "can't alloc memory for DOT11D\n");
-	memset(ieee->pDot11dInfo, 0, sizeof(struct rt_dot11d_info));
 	ieee->LinkDetectInfo.SlotIndex = 0;
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod = 0;


