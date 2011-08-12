Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1HNQKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab1HNQKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.754425311@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [87/90] ath9k_hw: Fix incorrect Tx control power in AR9003 template
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 15052f81d255eac44e745bc630b36aa86779ad9d upstream.

CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
Setting incorrect CTL power in calibration is causing lower tx power.
Tx power was reported as 3dBm while operating in channel 6 HT40+/
in channel 11 HT40- due to CTL powers in the calibration is set to
zero.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -306,7 +306,7 @@ static const struct ar9300_eeprom ar9300
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 
@@ -883,7 +883,7 @@ static const struct ar9300_eeprom ar9300
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 
@@ -2039,7 +2039,7 @@ static const struct ar9300_eeprom ar9300
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
 
-		{ { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		{ { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 		{ { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
 


