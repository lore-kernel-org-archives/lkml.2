Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab0LHB5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:57:37 -0500
Received: from kroah.org ([198.145.64.141]:48518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0LHA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:32 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.055079979@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [037/289] ath9k_hw: Set proper eeprom offset for AR9287 HTC devices
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit b5261cf4f3860bd772346a3e692683b6144dd44c upstream.

AR9287 based PCI & USB devices are differed in eeprom start offset.
So set proper the offset for HTC devices to read nvram correctly.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h         |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -37,7 +37,7 @@ static bool ath9k_hw_ar9287_fill_eeprom(
 	int addr, eep_start_loc;
 	eep_data = (u16 *)eep;
 
-	if (ah->hw_version.devid == 0x7015)
+	if (AR9287_HTC_DEVID(ah))
 		eep_start_loc = AR9287_HTC_EEP_START_LOC;
 	else
 		eep_start_loc = AR9287_EEP_START_LOC;
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -903,6 +903,10 @@
 	 ((_ah)->hw_version.devid == 0x7015) || \
 	 ((_ah)->hw_version.devid == 0x9018))
 
+#define AR9287_HTC_DEVID(_ah) \
+	(((_ah)->hw_version.devid == 0x7015) || \
+	 ((_ah)->hw_version.devid == 0x1200))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0


