Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1I1WkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1I1WkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.607584752@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [032/244] ath9k_hw: Fix STA (AR9485) bringup issue due to incorrect MAC address
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>

commit b503c7a273c0a3018ad11ea8c513c639120afbf4 upstream.

Due to some recent optimization done in the way the mac address
bytes are written into the OTP memory, some AR9485 chipsets were
forced to use the first byte from the eeprom template and the
remaining bytes are read from OTP.

AR9485 happens to use generic eeprom template which has 0x1 as
the first byte causes issues in bringing up the card.

So fixed the eeprom template accordingly to address the issue.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -68,7 +68,7 @@ static int ar9003_hw_power_interpolate(i
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
-	.macAddr = {1, 2, 3, 4, 5, 6},
+	.macAddr = {0, 2, 3, 4, 5, 6},
 	.custData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		     0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
 	.baseEepHeader = {


