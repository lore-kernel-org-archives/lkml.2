Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2A3Oq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:46:29 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42572 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352Ab2A3Oq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:46:26 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] ixj: fix Wsequence-point compiler warnings
Date: Mon, 30 Jan 2012 15:40:15 +0100
Message-Id: <1327934418-12674-13-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327934418-12674-1-git-send-email-danny.kukawka@bisect.de>
References: <1327934418-12674-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327934786;0abb323c;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some Wsequence-point compiler warnings in ixj.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/telephony/ixj.c |  194 ++++++++++++++++++++++++++---------------------
 1 files changed, 107 insertions(+), 87 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index d5f923b..7d02cae 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -5923,35 +5923,38 @@ static int ixj_build_filter_cadence(IXJ *j, IXJ_FILTER_CADENCE __user * cp)
 
 static void add_caps(IXJ *j)
 {
-	j->caps = 0;
-	j->caplist[j->caps].cap = PHONE_VENDOR_QUICKNET;
-	strcpy(j->caplist[j->caps].desc, "Quicknet Technologies, Inc. (www.quicknet.net)");
-	j->caplist[j->caps].captype = vendor;
-	j->caplist[j->caps].handle = j->caps++;
-	j->caplist[j->caps].captype = device;
+	int i = 0;
+	j->caplist[i].cap = PHONE_VENDOR_QUICKNET;
+	strcpy(j->caplist[i].desc, "Quicknet Technologies, Inc. (www.quicknet.net)");
+	j->caplist[i].captype = vendor;
+	j->caplist[i].handle = i;
+	i++;
+	j->caplist[i].captype = device;
 	switch (j->cardtype) {
 	case QTI_PHONEJACK:
-		strcpy(j->caplist[j->caps].desc, "Quicknet Internet PhoneJACK");
+		strcpy(j->caplist[i].desc, "Quicknet Internet PhoneJACK");
 		break;
 	case QTI_LINEJACK:
-		strcpy(j->caplist[j->caps].desc, "Quicknet Internet LineJACK");
+		strcpy(j->caplist[i].desc, "Quicknet Internet LineJACK");
 		break;
 	case QTI_PHONEJACK_LITE:
-		strcpy(j->caplist[j->caps].desc, "Quicknet Internet PhoneJACK Lite");
+		strcpy(j->caplist[i].desc, "Quicknet Internet PhoneJACK Lite");
 		break;
 	case QTI_PHONEJACK_PCI:
-		strcpy(j->caplist[j->caps].desc, "Quicknet Internet PhoneJACK PCI");
+		strcpy(j->caplist[i].desc, "Quicknet Internet PhoneJACK PCI");
 		break;
 	case QTI_PHONECARD:
-		strcpy(j->caplist[j->caps].desc, "Quicknet Internet PhoneCARD");
+		strcpy(j->caplist[i].desc, "Quicknet Internet PhoneCARD");
 		break;
 	}
-	j->caplist[j->caps].cap = j->cardtype;
-	j->caplist[j->caps].handle = j->caps++;
-	strcpy(j->caplist[j->caps].desc, "POTS");
-	j->caplist[j->caps].captype = port;
-	j->caplist[j->caps].cap = pots;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[i].cap = j->cardtype;
+	j->caplist[i].handle = i;
+	i++;
+	strcpy(j->caplist[i].desc, "POTS");
+	j->caplist[i].captype = port;
+	j->caplist[i].cap = pots;
+	j->caplist[i].handle = i;
+	i++;
 
  	/* add devices that can do speaker/mic */
 	switch (j->cardtype) {
@@ -5959,10 +5962,11 @@ static void add_caps(IXJ *j)
 	case QTI_LINEJACK:
 	case QTI_PHONEJACK_PCI:
 	case QTI_PHONECARD:
-		strcpy(j->caplist[j->caps].desc, "SPEAKER");
-		j->caplist[j->caps].captype = port;
-		j->caplist[j->caps].cap = speaker;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "SPEAKER");
+		j->caplist[i].captype = port;
+		j->caplist[i].cap = speaker;
+		j->caplist[i].handle = i;
+		i++;
         default:
      		break;
 	}
@@ -5970,10 +5974,11 @@ static void add_caps(IXJ *j)
  	/* add devices that can do handset */
 	switch (j->cardtype) {
 	case QTI_PHONEJACK:
-		strcpy(j->caplist[j->caps].desc, "HANDSET");
-		j->caplist[j->caps].captype = port;
-		j->caplist[j->caps].cap = handset;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "HANDSET");
+		j->caplist[i].captype = port;
+		j->caplist[i].cap = handset;
+		j->caplist[i].handle = i;
+		i++;
 		break;
         default:
      		break;
@@ -5982,94 +5987,109 @@ static void add_caps(IXJ *j)
  	/* add devices that can do PSTN */
 	switch (j->cardtype) {
 	case QTI_LINEJACK:
-		strcpy(j->caplist[j->caps].desc, "PSTN");
-		j->caplist[j->caps].captype = port;
-		j->caplist[j->caps].cap = pstn;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "PSTN");
+		j->caplist[i].captype = port;
+		j->caplist[i].cap = pstn;
+		j->caplist[i].handle = i;
+		i++;
 		break;
         default:
      		break;
 	}
 
 	/* add codecs - all cards can do uLaw, linear 8/16, and Windows sound system */
-	strcpy(j->caplist[j->caps].desc, "ULAW");
-	j->caplist[j->caps].captype = codec;
-	j->caplist[j->caps].cap = ULAW;
-	j->caplist[j->caps].handle = j->caps++;
-
-	strcpy(j->caplist[j->caps].desc, "LINEAR 16 bit");
-	j->caplist[j->caps].captype = codec;
-	j->caplist[j->caps].cap = LINEAR16;
-	j->caplist[j->caps].handle = j->caps++;
-
-	strcpy(j->caplist[j->caps].desc, "LINEAR 8 bit");
-	j->caplist[j->caps].captype = codec;
-	j->caplist[j->caps].cap = LINEAR8;
-	j->caplist[j->caps].handle = j->caps++;
-
-	strcpy(j->caplist[j->caps].desc, "Windows Sound System");
-	j->caplist[j->caps].captype = codec;
-	j->caplist[j->caps].cap = WSS;
-	j->caplist[j->caps].handle = j->caps++;
+	strcpy(j->caplist[i].desc, "ULAW");
+	j->caplist[i].captype = codec;
+	j->caplist[i].cap = ULAW;
+	j->caplist[i].handle = i;
+	i++;
+
+	strcpy(j->caplist[i].desc, "LINEAR 16 bit");
+	j->caplist[i].captype = codec;
+	j->caplist[i].cap = LINEAR16;
+	j->caplist[i].handle = i;
+	i++;
+
+	strcpy(j->caplist[i].desc, "LINEAR 8 bit");
+	j->caplist[i].captype = codec;
+	j->caplist[i].cap = LINEAR8;
+	j->caplist[i].handle = i;
+	i++;
+
+	strcpy(j->caplist[i].desc, "Windows Sound System");
+	j->caplist[i].captype = codec;
+	j->caplist[i].cap = WSS;
+	j->caplist[i].handle = i;
+	i++;
 
 	/* software ALAW codec, made from ULAW */
-	strcpy(j->caplist[j->caps].desc, "ALAW");
-	j->caplist[j->caps].captype = codec;
-	j->caplist[j->caps].cap = ALAW;
-	j->caplist[j->caps].handle = j->caps++;
+	strcpy(j->caplist[i].desc, "ALAW");
+	j->caplist[i].captype = codec;
+	j->caplist[i].cap = ALAW;
+	j->caplist[i].handle = i;
+	i++;
 
 	/* version 12 of the 8020 does the following codecs in a broken way */
 	if (j->dsp.low != 0x20 || j->ver.low != 0x12) {
-		strcpy(j->caplist[j->caps].desc, "G.723.1 6.3kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = G723_63;
-		j->caplist[j->caps].handle = j->caps++;
-
-		strcpy(j->caplist[j->caps].desc, "G.723.1 5.3kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = G723_53;
-		j->caplist[j->caps].handle = j->caps++;
-
-		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.8kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = TS48;
-		j->caplist[j->caps].handle = j->caps++;
-
-		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.1kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = TS41;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "G.723.1 6.3kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = G723_63;
+		j->caplist[i].handle = i;
+		i++;
+
+		strcpy(j->caplist[i].desc, "G.723.1 5.3kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = G723_53;
+		j->caplist[i].handle = i;
+		i++;
+
+		strcpy(j->caplist[i].desc, "TrueSpeech 4.8kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = TS48;
+		j->caplist[i].handle = i;
+		i++;
+
+		strcpy(j->caplist[i].desc, "TrueSpeech 4.1kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = TS41;
+		j->caplist[i].handle = i;
+		i++;
 	}
 
 	/* 8020 chips can do TS8.5 native, and 8021/8022 can load it */
 	if (j->dsp.low == 0x20 || j->flags.ts85_loaded) {
-		strcpy(j->caplist[j->caps].desc, "TrueSpeech 8.5kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = TS85;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "TrueSpeech 8.5kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = TS85;
+		j->caplist[i].handle = i;
+		i++;
 	}
 
 	/* 8021 chips can do G728 */
 	if (j->dsp.low == 0x21) {
-		strcpy(j->caplist[j->caps].desc, "G.728 16kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = G728;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "G.728 16kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = G728;
+		j->caplist[i].handle = i;
+		i++;
 	}
 
 	/* 8021/8022 chips can do G729 if loaded */
 	if (j->dsp.low != 0x20 && j->flags.g729_loaded) {
-		strcpy(j->caplist[j->caps].desc, "G.729A 8kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = G729;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "G.729A 8kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = G729;
+		j->caplist[i].handle = i;
+		i++;
 	}
 	if (j->dsp.low != 0x20 && j->flags.g729_loaded) {
-		strcpy(j->caplist[j->caps].desc, "G.729B 8kbps");
-		j->caplist[j->caps].captype = codec;
-		j->caplist[j->caps].cap = G729B;
-		j->caplist[j->caps].handle = j->caps++;
+		strcpy(j->caplist[i].desc, "G.729B 8kbps");
+		j->caplist[i].captype = codec;
+		j->caplist[i].cap = G729B;
+		j->caplist[i].handle = i;
+		i++;
 	}
+	j->caps = i;
 }
 
 static int capabilities_check(IXJ *j, struct phone_capability *pcreq)
-- 
1.7.7.3

