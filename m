Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1FFTHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:07:47 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:35716 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1FFTHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ximI2Ev8f+7TCbu5zRapABMLK5p+qgB8q9bpsvV08LtDu0+ZuIJTPi8VEo8qIJ1JDo
         ieIimNjTgLObPwX0Ste75MePDmy7PFvE+lHINyEw8GFROFQywrbtCbFd/4lEbaFHJmKi
         25rrmIaU7fYEKTmRGmXEQc0jic/4fBXo0qLPo=
Subject: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
From: anish <anish198519851985@gmail.com>
To: gregkh@suse.de, jic23@cam.ac.uk, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 00:37:37 +0530
Message-ID: <1307387257.4327.12.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

Replace kmalloc with local variables as it was un-necessary and
also removed the redudant code after this change.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/staging/iio/accel/kxsd9.c      |   19 +++----------------
 drivers/staging/iio/adc/max1363_core.c |    3 +--
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
index 431aa0f..7f6e6e5 100644
--- a/drivers/staging/iio/accel/kxsd9.c
+++ b/drivers/staging/iio/accel/kxsd9.c
@@ -255,7 +255,10 @@ static const struct attribute_group kxsd9_attribute_group = {
 
 static int __devinit kxsd9_power_up(struct spi_device *spi)
 {
+	struct spi_message msg;
 	int ret;
+	u8 tx[2], tx2[2];
+
 	struct spi_transfer xfers[2] = {
 		{
 			.bits_per_word = 8,
@@ -267,19 +270,7 @@ static int __devinit kxsd9_power_up(struct spi_device *spi)
 			.cs_change = 1,
 		},
 	};
-	struct spi_message msg;
-	u8 *tx2;
-	u8 *tx = kmalloc(2, GFP_KERNEL);
 
-	if (tx == NULL) {
-		ret = -ENOMEM;
-		goto error_ret;
-	}
-	tx2 = kmalloc(2, GFP_KERNEL);
-	if (tx2 == NULL) {
-		ret = -ENOMEM;
-		goto error_free_tx;
-	}
 	tx[0] = 0x0d;
 	tx[1] = 0x40;
 
@@ -293,10 +284,6 @@ static int __devinit kxsd9_power_up(struct spi_device *spi)
 	spi_message_add_tail(&xfers[1], &msg);
 	ret = spi_sync(spi, &msg);
 
-	kfree(tx2);
-error_free_tx:
-	kfree(tx);
-error_ret:
 	return ret;
 
 };
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 1037087..0026242 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -207,7 +207,7 @@ static int max1363_write_basic_config(struct i2c_client *client,
 				      unsigned char d2)
 {
 	int ret;
-	u8 *tx_buf = kmalloc(2, GFP_KERNEL);
+	u8 tx_buf[2];
 
 	if (!tx_buf)
 		return -ENOMEM;
@@ -215,7 +215,6 @@ static int max1363_write_basic_config(struct i2c_client *client,
 	tx_buf[1] = d2;
 
 	ret = i2c_master_send(client, tx_buf, 2);
-	kfree(tx_buf);
 
 	return (ret > 0) ? 0 : ret;
 }
-- 
1.7.0.4




