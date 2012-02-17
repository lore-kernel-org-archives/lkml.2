Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2BQBA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41049 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838Ab2BQBA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:26 -0500
X-Sasl-enc: +89dpUm+KyvgcFWn85mHDdbFyTVTwCZvQCn16jj82jVv 1329440425
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.410388687@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [10/28] hwmon: (f75375s) Fix bit shifting in f75375_write16
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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


