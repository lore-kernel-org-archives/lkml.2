Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab1IBJlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:41:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38033 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab1IBJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:41:12 -0400
Date: Fri, 2 Sep 2011 12:41:07 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Bryan Freed <bfreed@chromium.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org,
        Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
Message-ID: <20110902094107.GA2846@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't overwrite the error code.  For example, the lower layers can
> return -EAGAIN and that's more useful than just returning -EIO every
> time.
Ahh.. Thanks a lot for explaining this.

> Your fix works, but it's not very clean.  Just add a "*id = ret;"
> line before the "return 0;" and that's it.  (It doesn't make sense
> to pass a pointer to "id" and not use it).
Dan, yes, I agree with you. This fix is much much better than what I 
had in my mind.

> Yikes - I wonder why my various compilers don't throw that up.
I guess, in "iio-blue.git" tree, the 'id = 0' suppresses this warning.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index f25243b..55012ff 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -226,7 +226,7 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
 	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_ID);
 	if (ret < 0)
 		return ret;
-
+	*id = ret;
 	return 0;
 }
 
