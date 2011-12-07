Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab1LGRDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:03:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1LGRDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:00 2011
Message-Id: <20111207165600.523797414@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:34 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, "Sheng-Hui J. Chu" <jeffchu@broadcom.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [01/27] i2c-algo-bit: Generate correct i2c address sequence for 10-bit target
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>

commit cc6bcf7d2ec2234e7b41770185e4dc826390185e upstream.

The wrong bits were put on the wire, fix that.

This fixes kernel bug #42562.

Signed-off-by: Sheng-Hui J. Chu <jeffchu@broadcom.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/algos/i2c-algo-bit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -471,7 +471,7 @@ static int bit_doAddress(struct i2c_adap
 
 	if (flags & I2C_M_TEN) {
 		/* a ten bit address */
-		addr = 0xf0 | ((msg->addr >> 7) & 0x03);
+		addr = 0xf0 | ((msg->addr >> 7) & 0x06);
 		bit_dbg(2, &i2c_adap->dev, "addr0: %d\n", addr);
 		/* try extended address code...*/
 		ret = try_address(i2c_adap, addr, retries);
@@ -481,7 +481,7 @@ static int bit_doAddress(struct i2c_adap
 			return -EREMOTEIO;
 		}
 		/* the remaining 8 bit address */
-		ret = i2c_outb(i2c_adap, msg->addr & 0x7f);
+		ret = i2c_outb(i2c_adap, msg->addr & 0xff);
 		if ((ret != 1) && !nak_ok) {
 			/* the chip did not ack / xmission error occurred */
 			dev_err(&i2c_adap->dev, "died at 2nd address code\n");


