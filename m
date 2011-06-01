Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161243Ab1FAIHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:07:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:43132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220Ab1FAIHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:07:46 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:43 2011
Message-Id: <20110601080242.581286247@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:13 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ray Li <ray.li@greenwavereality.com>,
        Kathy Giori <kathy.giori@atheros.com>,
        Aeolus Yang <aeolus.yang@atheros.com>, compat@orbit-lab.org,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [017/146] ath9k_hw: Fix STA connection issues with AR9380 (XB113).
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit be0e6aa5a0c487a2a0880dda8bc70f7f1860fc39 upstream.

XB113 (AR9380) 3x3 SB 5G only cards were failing to connect to APs
due to incorrect xpabiaslevel configuration. fix it.

Cc: Ray Li <ray.li@greenwavereality.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: compat@orbit-lab.org
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -922,7 +922,7 @@ static const struct ar9300_eeprom ar9300
 		.db_stage2 = {3, 3, 3}, /* 3 chain */
 		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
 		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
-		.xpaBiasLvl = 0,
+		.xpaBiasLvl = 0xf,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
 		.txClip = 3, /* 4 bits tx_clip, 4 bits dac_scale_cck */


