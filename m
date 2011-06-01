Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162065Ab1FAJGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:06:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162010Ab1FAIQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:40 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:59 2011
Message-Id: <20110601081058.913174764@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:48 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fiona Cain <fcain@atheros.com>, Zhen Xie <Zhen.Xie@atheros.com>,
        Kathy Giori <kathy.giori@atheros.com>,
        Neha Choksi <neha.choksi@atheros.com>,
        Wayne Daniel <wayne.daniel@atheros.com>,
        Gaurav Jauhar <gaurav.jauhar@atheros.com>,
        Samira Naraghi <samira.naraghi@atheros.com>,
        Ashok Chennupati <ashok.chennupati@atheros.com>,
        Lance Zimmerman <lance.zimmerman@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [018/165] ath9k_hw: fix power for the HT40 duplicate frames
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1904
Lines: 49

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit cf3a03b9c99a0b2715741d116f50f513f545bb2d upstream.

With AR9003 at about ~ 10 feet from an AP that uses RTS / CTS you
will be able to associate but not not get data through given that
the power for the rates used was set too low. This increases the
power and permits data connectivity at longer distances from
access points when connected with HT40. Without this you will not
get any data through when associated to APs configured in HT40
at about more than 10 feet away.

Cc: Fiona Cain <fcain@atheros.com>
Cc: Zhen Xie <Zhen.Xie@Atheros.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Neha Choksi <neha.choksi@atheros.com>
Cc: Wayne Daniel <wayne.daniel@atheros.com>
Cc: Gaurav Jauhar <gaurav.jauhar@atheros.com>
Cc: Samira Naraghi <samira.naraghi@atheros.com>
CC: Ashok Chennupati <ashok.chennupati@atheros.com>
Cc: Lance Zimmerman <lance.zimmerman@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3994,6 +3994,16 @@ static int ar9003_hw_tx_power_regwrite(s
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 0)
 	    );
 
+        /* Write the power for duplicated frames - HT40 */
+
+        /* dup40_cck (LSB), dup40_ofdm, ext20_cck, ext20_ofdm (MSB) */
+	REG_WRITE(ah, 0xa3e0,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24],  8) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L],  0)
+	    );
+
 	/* Write the HT20 power per rate set */
 
 	/* 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB) */


