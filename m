Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0KZLfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:35:08 -0500
Received: from mail.sysgo.com ([195.145.229.155]:57922 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0KZLfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:35:06 -0500
Date: Fri, 26 Nov 2010 12:35:03 +0100
From: Pavel Machek <pma@sysgo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, ath9k-devel@venema.h4ckr.net,
        Sujith.Manoharan@atheros.com
Cc: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com
Subject: [PATCH] ath9k_htc: cleanup eeprom endiannes handling
Message-ID: <20101126113503.GA28137@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126112737.GB11857@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are already in-place byte swapping macros in Linux, use them.

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 4fa4d8e..ee4e893 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -117,47 +117,25 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		sum ^= *eepdata++;
 
 	if (need_swap) {
-		u32 integer;
-		u16 word;
-
 		ath_print(common, ATH_DBG_EEPROM,
 			  "EEPROM Endianness is not native.. Changing\n");
 
-		word = swab16(eep->baseEepHeader.length);
-		eep->baseEepHeader.length = word;
-
-		word = swab16(eep->baseEepHeader.checksum);
-		eep->baseEepHeader.checksum = word;
-
-		word = swab16(eep->baseEepHeader.version);
-		eep->baseEepHeader.version = word;
-
-		word = swab16(eep->baseEepHeader.regDmn[0]);
-		eep->baseEepHeader.regDmn[0] = word;
-
-		word = swab16(eep->baseEepHeader.regDmn[1]);
-		eep->baseEepHeader.regDmn[1] = word;
-
-		word = swab16(eep->baseEepHeader.rfSilent);
-		eep->baseEepHeader.rfSilent = word;
-
-		word = swab16(eep->baseEepHeader.blueToothOptions);
-		eep->baseEepHeader.blueToothOptions = word;
-
-		word = swab16(eep->baseEepHeader.deviceCap);
-		eep->baseEepHeader.deviceCap = word;
-
-		integer = swab32(eep->modalHeader.antCtrlCommon);
-		eep->modalHeader.antCtrlCommon = integer;
+		swab16s(&eep->baseEepHeader.length);
+		swab16s(&eep->baseEepHeader.checksum);
+		swab16s(&eep->baseEepHeader.version);
+		swab16s(&eep->baseEepHeader.regDmn[0]);
+		swab16s(&eep->baseEepHeader.regDmn[1]);
+		swab16s(&eep->baseEepHeader.rfSilent);
+		swab16s(&eep->baseEepHeader.blueToothOptions);
+		swab16s(&eep->baseEepHeader.deviceCap);
+		swab32s(&eep->modalHeader.antCtrlCommon);
 
 		for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
-			integer = swab32(eep->modalHeader.antCtrlChain[i]);
-			eep->modalHeader.antCtrlChain[i] = integer;
+			swab32s(&eep->modalHeader.antCtrlChain[i]);
 		}
 
 		for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
-			word = swab16(eep->modalHeader.spurChans[i].spurChan);
-			eep->modalHeader.spurChans[i].spurChan = word;
+			swab16s(&eep->modalHeader.spurChans[i].spurChan);
 		}
 	}
 
