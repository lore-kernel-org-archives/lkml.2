Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3AIIkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:40:07 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38939 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3AIIkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:40:06 -0500
From: Patrik Karlin <patrik.karlin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Patrik Karlin <patrik.karlin@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=201/3=5D=20staging=3A=20rtl8192u=3A=20fixed=20some=20coding=20style=20issues=20in=20r8192U=5Fcore=2Ec?=
Date: Wed,  9 Jan 2013 09:39:44 +0100
Message-Id: <1357720784-4226-1-git-send-email-patrik.karlin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <n>
References: <n>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some coding style issues. in r8192U_core.c
No logic is changed.

Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   80 +++++++++++++++-----------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 56367f2..c2260de 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -190,53 +190,47 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
 	struct ieee80211_device* ieee = priv->ieee80211;
 	switch (channel_plan)
 	{
-		case COUNTRY_CODE_FCC:
-		case COUNTRY_CODE_IC:
-		case COUNTRY_CODE_ETSI:
-		case COUNTRY_CODE_SPAIN:
-		case COUNTRY_CODE_FRANCE:
-		case COUNTRY_CODE_MKK:
-		case COUNTRY_CODE_MKK1:
-		case COUNTRY_CODE_ISRAEL:
-		case COUNTRY_CODE_TELEC:
-		case COUNTRY_CODE_MIC:
-		{
-			Dot11d_Init(ieee);
-			ieee->bGlobalDomain = false;
-			//actually 8225 & 8256 rf chips only support B,G,24N mode
-			if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256))
-			{
-				min_chan = 1;
-				max_chan = 14;
-			}
-			else
-			{
-				RT_TRACE(COMP_ERR, "unknown rf chip, can't set channel map in function:%s()\n", __FUNCTION__);
-			}
-			if (ChannelPlan[channel_plan].Len != 0){
-				// Clear old channel map
-				memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
-				// Set new channel map
-				for (i=0;i<ChannelPlan[channel_plan].Len;i++)
-				{
-					if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
+	case COUNTRY_CODE_FCC:
+	case COUNTRY_CODE_IC:
+	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_SPAIN:
+	case COUNTRY_CODE_FRANCE:
+	case COUNTRY_CODE_MKK:
+	case COUNTRY_CODE_MKK1:
+	case COUNTRY_CODE_ISRAEL:
+	case COUNTRY_CODE_TELEC:
+	case COUNTRY_CODE_MIC:	
+		Dot11d_Init(ieee);
+		ieee->bGlobalDomain = false;
+		//actually 8225 & 8256 rf chips only support B,G,24N mode
+		if ((priv->rf_chip == RF_8225) || (priv->rf_chip == RF_8256)) {
+			min_chan = 1;
+			max_chan = 14;
+		}
+		else {
+			RT_TRACE(COMP_ERR, "unknown rf chip, can't set channel map in function:%s()\n", __FUNCTION__);
+		}
+		if (ChannelPlan[channel_plan].Len != 0) {
+			// Clear old channel map
+			memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
+			// Set new channel map
+			for (i=0;i<ChannelPlan[channel_plan].Len;i++) {
+				if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
 					break;
-					GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
-				}
+				GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
 			}
-			break;
 		}
-		case COUNTRY_CODE_GLOBAL_DOMAIN:
-		{
-			GET_DOT11D_INFO(ieee)->bEnabled = 0;//this flag enabled to follow 11d country IE setting, otherwise, it shall follow global domain settings.
-			Dot11d_Reset(ieee);
-			ieee->bGlobalDomain = true;
-			break;
-		}
-		default:
-			break;
+		break;
+
+	case COUNTRY_CODE_GLOBAL_DOMAIN:
+		GET_DOT11D_INFO(ieee)->bEnabled = 0;//this flag enabled to follow 11d country IE setting, otherwise, it shall follow global domain settings.
+		Dot11d_Reset(ieee);
+		ieee->bGlobalDomain = true;
+		break;
+	
+	default:
+		break;
 	}
-	return;
 }
 
 
-- 
1.7.10.4

