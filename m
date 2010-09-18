Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0IRTPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:12 -0400
Received: from kroah.org ([198.145.64.141]:43314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0IRTPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:02 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.190086315@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [034/129] ath9k_hw: Fix EEPROM uncompress block reading on AR9003
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 803288e61e346ba367373bc7d5eeb6e11c81a33c upstream.

The EEPROM is compressed on AR9003, upon decompression
the wrong upper limit was being used for the block which
prevented the 5 GHz CTL indexes from being used, which are
stored towards the end of the EEPROM block. This fix allows
the actual intended regulatory limits to be used on AR9003
hardware.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -768,7 +768,7 @@ static bool ar9300_uncompress_block(stru
 		length = block[it+1];
 		length &= 0xff;
 
-		if (length > 0 && spot >= 0 && spot+length < mdataSize) {
+		if (length > 0 && spot >= 0 && spot+length <= mdataSize) {
 			ath_print(common, ATH_DBG_EEPROM,
 				  "Restore at %d: spot=%d "
 				  "offset=%d length=%d\n",


