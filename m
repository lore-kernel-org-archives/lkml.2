Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396Ab2CAVuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292Ab2CAVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.225.39 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213922.547529216@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 02/34] hwmon: (f75375s) Fix bit shifting in f75375_write16
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaus Schulz <schulz@macnetix.de>

commit eb2f255b2d360df3f500042a2258dcf2fcbe89a2 upstream.

In order to extract the high byte of the 16-bit word, shift the word to
the right, not to the left.

Signed-off-by: Nikolaus Schulz <mail@microschulz.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/f75375s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -159,7 +159,7 @@ static inline void f75375_write8(struct
 static inline void f75375_write16(struct i2c_client *client, u8 reg,
 		u16 value)
 {
-	int err = i2c_smbus_write_byte_data(client, reg, (value << 8));
+	int err = i2c_smbus_write_byte_data(client, reg, (value >> 8));
 	if (err)
 		return;
 	i2c_smbus_write_byte_data(client, reg + 1, (value & 0xFF));


