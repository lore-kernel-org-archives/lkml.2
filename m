Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab0HFSf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:57 -0400
Received: from kroah.org ([198.145.64.141]:48641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896Ab0HFSfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.657200051@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [18/38] ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 03b4776c408d2f4bf3a5d204e223724d154716d1 upstream.

PDADC values were only generated for values surrounding the target
index, however not for the target index itself, leading to a minor
error in the generated curve.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -729,7 +729,7 @@ static void ath9k_hw_get_def_gain_bounda
 				    vpdTableI[i][sizeCurrVpdTable - 2]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
 
-		if (tgtIndex > maxIndex) {
+		if (tgtIndex >= maxIndex) {
 			while ((ss <= tgtIndex) &&
 			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
 				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +


