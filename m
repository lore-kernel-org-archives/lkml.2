Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1GIFyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:54:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57707 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab1GIFyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:13 -0400
X-Sasl-enc: Voq35ybHcQUXUQlFT58u4f8PlYyIpFK0Kk7r+uenmC/X 1310190852
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:19 2011
Message-Id: <20110708225119.722174548@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:49:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [09/35] ath9k: Fix suspend/resume when no interface is UP
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -276,6 +276,12 @@ static int ath_pci_resume(struct pci_dev
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	/* The device has to be moved to FULLSLEEP forcibly.
+	 * Otherwise the chip never moved to full sleep,
+	 * when no interface is up.
+	 */
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+
 	return 0;
 }
 


