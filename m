Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1I1Wm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1I1Wm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:37 2011
Message-Id: <20110928220136.931844821@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [110/244] ath9k_hw: fix calibration on 5 ghz
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 0e4660cbe51276e86dbdab17228733dbcdb49249 upstream.

ADC calibrations cannot run on 5 GHz with fast clock enabled. They
need to be disabled, otherwise they'll hang and IQ mismatch calibration
will not be run either.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Adrian Chadd <adrian@freebsd.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -41,7 +41,8 @@ static bool ar9002_hw_is_cal_supported(s
 	case ADC_DC_CAL:
 		/* Run ADC Gain Cal for non-CCK & non 2GHz-HT20 only */
 		if (!IS_CHAN_B(chan) &&
-		    !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
+		    !((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan)) &&
+		      IS_CHAN_HT20(chan)))
 			supported = true;
 		break;
 	}


