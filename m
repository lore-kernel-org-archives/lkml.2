Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab1KJDYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:24:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935Ab1KJDX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:06 2011
Message-Id: <20111109212706.478226578@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [061/262] ath9k_hw: Fix number of GPIO pins for AR9287/9300
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit 6321eb0977b011ac61dfca36e7c69b2c4325b104 upstream.

this patch fixes the assumption of maximum number of GPIO pins present
in AR9287/AR9300. this fix is essential as we might encounter some
functionality issues involved in accessing the status of GPIO pins which
are all incorrectly assumed to be not within the range of max_num_gpio
of AR9300/AR9287 chipsets

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1931,6 +1931,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw
 		pCap->num_gpio_pins = AR9271_NUM_GPIO;
 	else if (AR_DEVID_7010(ah))
 		pCap->num_gpio_pins = AR7010_NUM_GPIO;
+	else if (AR_SREV_9300_20_OR_LATER(ah))
+		pCap->num_gpio_pins = AR9300_NUM_GPIO;
+	else if (AR_SREV_9287_11_OR_LATER(ah))
+		pCap->num_gpio_pins = AR9287_NUM_GPIO;
 	else if (AR_SREV_9285_12_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
 	else if (AR_SREV_9280_20_OR_LATER(ah))


