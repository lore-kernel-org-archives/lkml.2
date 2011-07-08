Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1GHFDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1GHFC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.366461976@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [048/107] ath9k: Fix suspend/resume when no interface is UP
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit c31eb8e926835582cd186b33a7a864880a4c0c79 upstream.

When no interface has been brought up, the chip's power
state continued as AWAKE. So during resume, the chip never
been powered up.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -278,6 +278,12 @@ static int ath_pci_suspend(struct device
 
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	/* The device has to be moved to FULLSLEEP forcibly.
+	 * Otherwise the chip never moved to full sleep,
+	 * when no interface is up.
+	 */
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+
 	return 0;
 }
 


