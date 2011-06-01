Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162025Ab1FAIQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:16:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161994Ab1FAIQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:45 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:00 2011
Message-Id: <20110601081059.571990943@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:49 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fiona Cain <Fiona.Cain@atheros.com>,
        Ray Li <ray.li@greenwavereality.com>,
        Kathy Giori <kathy.giori@atheros.com>,
        Aeolus Yang <aeolus.yang@atheros.com>,
        Dan Friedman <dan.friedman@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [019/165] ath9k_hw: fix dual band assumption for XB113
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1271
Lines: 35

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 9ba7f4f5eba5f4b44c7796bbad29f8ec3a7d5864 upstream.

The XB113 cards are single band, 5 GHz-only, but the
default settings were configured to assume it was dual
band. Users of these cards then would see 2.4 GHz channels
but you would never get any scan results from these channels
given that the radio is not present.

Cc: Fiona Cain <Fiona.Cain@atheros.com>
Cc: Ray Li <ray.li@greenwavereality.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Dan Friedman <dan.friedman@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -652,7 +652,7 @@ static const struct ar9300_eeprom ar9300
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,


