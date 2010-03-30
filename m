Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0CaARK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:17:10 -0400
Received: from kroah.org ([198.145.64.141]:51766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab0C3XRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:32 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:05 2010
Message-Id: <20100330225605.139131792@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com, mb@bu3sch.de, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       Luis Rodriguez <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [014/116] ath5k: dont use external sleep clock in AP mode
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 5d6ce628f986d1a3c523cbb0a5a52095c48cc332 upstream

When using the external sleep clock in AP mode, the
TSF increments too quickly, causing beacon interval
to be much lower than it is supposed to be, resulting
in lots of beacon-not-ready interrupts.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Luis Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1382,8 +1382,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah,
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
 	 * exists */
-	if (ah->ah_version == AR5K_AR5212)
-			ath5k_hw_set_sleep_clock(ah, true);
+	if (ah->ah_version == AR5K_AR5212 &&
+	    ah->ah_op_mode != NL80211_IFTYPE_AP)
+		ath5k_hw_set_sleep_clock(ah, true);
 
 	/*
 	 * Disable beacons and reset the register


