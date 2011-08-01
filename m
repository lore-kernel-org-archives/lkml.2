Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1HAX0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1HAXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.384509796@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [08/70] hwmon: (lm95241) Fix chip detection code
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 27739e694a3c34b5e371575d74e500d60111c689 upstream.

The LM95241 driver accepts every chip ID equal to or larger than 0xA4 as its
own, and other chips such as LM95245 use chip IDs in the accepted ID range.
This results in false chip detection.

Fix problem by accepting only the known LM95241 chip ID.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm95241.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -339,7 +339,7 @@ static int lm95241_detect(struct i2c_cli
 	if ((i2c_smbus_read_byte_data(new_client, LM95241_REG_R_MAN_ID)
 	     == MANUFACTURER_ID)
 	    && (i2c_smbus_read_byte_data(new_client, LM95241_REG_R_CHIP_ID)
-		>= DEFAULT_REVISION)) {
+		== DEFAULT_REVISION)) {
 		name = DEVNAME;
 	} else {
 		dev_dbg(&adapter->dev, "LM95241 detection failed at 0x%02x\n",


