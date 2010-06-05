Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab0FEOOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:14:44 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:5147 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933432Ab0FEOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293881"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <kernel.online@gilksonline.com>
Subject: [PATCH 03/13] Remove checkpath.pl issues to line 200
Date: Sat,  5 Jun 2010 22:12:27 +0800
Message-Id: <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Gilks <kernel.online@gilksonline.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   39 ++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index dd42a35..13c7baf 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -169,24 +169,35 @@ static struct usb_driver rtl8192_usb_driver = {
 
 #ifdef ENABLE_DOT11D
 
-typedef struct _CHANNEL_LIST
-{
+typedef struct _CHANNEL_LIST {
 	u8	Channel[32];
 	u8	Len;
-}CHANNEL_LIST, *PCHANNEL_LIST;
+} CHANNEL_LIST, *PCHANNEL_LIST;
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64,149,153,157,161,165},24},  		//FCC
-	{{1,2,3,4,5,6,7,8,9,10,11},11},                    				//IC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},  	//ETSI
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},    //Spain. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},  	//France. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},	//MKK					//MKK
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},//MKK1
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},	//Israel.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},			// For 11a , TELEC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64}, 22},    //MIC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64,
+				149, 153, 157, 161, 165}, 24},	/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},		/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56,
+					60, 64}, 21},		/* ETSI */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},
+						/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},
+						/* France. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52,
+					56, 60, 64}, 22},	/* MKK */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52,
+					56, 60, 64}, 22},	/* MKK1 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	/* Israel. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52,
+					56, 60, 64}, 22},
+						/* For 11a , TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52,
+					56, 60, 64}, 22},	/* MIC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}
+		/* For Global Domain. 1-11:active scan, 12-14 passive scan.
+		 * //+YJ, 080626
+		 */
 };
 
 static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
-- 
1.6.3.3

