Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab1BPBme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:42:34 -0500
Received: from kroah.org ([198.145.64.141]:38925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab1BPATq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.632671786@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jack Lee <jlee@atheros.com>,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [065/272] ath9k_hw: Fix system hang when resuming from S3/S4
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 5b64aa72ead6f8be488d2be7af579f0d69fb7a6e upstream.

The bit 6 & 7 of AR_WA (0x4004) should be enabled only
for the chips that are supporting L0s functionality
while resuming back from S3/S4.

Enabling these bits for AR9280 is causing system hang
within a few S3/S4-resume cycles.

Cc: Jack Lee <jlee@atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -444,9 +444,8 @@ static void ar9002_hw_configpcipowersave
 		}
 
 		/* WAR for ASPM system hang */
-		if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
+		if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
 			val |= (AR_WA_BIT6 | AR_WA_BIT7);
-		}
 
 		if (AR_SREV_9285E_20(ah))
 			val |= AR_WA_BIT23;


