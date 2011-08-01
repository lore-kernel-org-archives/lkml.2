Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1HAXfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:35:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1HAXZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.421298104@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [38/70] ath9k: Fix tx throughput drops for AR9003 chips with AES encryption
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 4f6760b01bda625e9555e16d8e9ba8126a9c9498 upstream.

While sending aggregated frames in AES, the AR5416 chips
required additional padding b/w subframes. This workaround
is not needed for edma (AR9003 family) chips. With this patch
~4Mbps thoughput improvement was observed in clear environment.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -662,7 +662,8 @@ static int ath_compute_num_delims(struct
 	 * TODO - this could be improved to be dependent on the rate.
 	 *      The hardware can keep up at lower rates, but not higher rates
 	 */
-	if (fi->keyix != ATH9K_TXKEYIX_INVALID)
+	if ((fi->keyix != ATH9K_TXKEYIX_INVALID) &&
+	    !(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA))
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*


