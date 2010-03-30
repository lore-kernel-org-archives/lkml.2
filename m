Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0C3XyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:54:00 -0400
Received: from kroah.org ([198.145.64.141]:45708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab0C3XTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:24 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:29 2010
Message-Id: <20100330224729.251927350@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [014/156] ath5k: dont use external sleep clock in AP mode
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 5d6ce628f986d1a3c523cbb0a5a52095c48cc332 upstream.

When using the external sleep clock in AP mode, the
TSF increments too quickly, causing beacon interval
to be much lower than it is supposed to be, resulting
in lots of beacon-not-ready interrupts.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1371,8 +1371,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah,
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


