Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab0EYSS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:18:29 -0400
Received: from kroah.org ([198.145.64.141]:44424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab0EYSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:39 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:14 2010
Message-Id: <20100525181214.335506476@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Oleg Ryjkov <oryjkov@gmail.com>
Subject: [23/25] i2c-i801: Dont use the block buffer for I2C block writes
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit c074c39d62306efa5ba7c69c1a1531bc7333d252 upstream.

Experience has shown that the block buffer can only be used for SMBus
(not I2C) block transactions, even though the datasheet doesn't
mention this limitation.

Reported-by: Felix Rubinstein <felixru@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Oleg Ryjkov <oryjkov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-i801.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -413,9 +413,11 @@ static int i801_block_transaction(union
 		data->block[0] = 32;	/* max for SMBus block reads */
 	}
 
+	/* Experience has shown that the block buffer can only be used for
+	   SMBus (not I2C) block transactions, even though the datasheet
+	   doesn't mention this limitation. */
 	if ((i801_features & FEATURE_BLOCK_BUFFER)
-	 && !(command == I2C_SMBUS_I2C_BLOCK_DATA
-	      && read_write == I2C_SMBUS_READ)
+	 && command != I2C_SMBUS_I2C_BLOCK_DATA
 	 && i801_set_block_buffer_mode() == 0)
 		result = i801_block_transaction_by_block(data, read_write,
 							 hwpec);


