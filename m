Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1LGQVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126Ab1LGQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.019617266@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:05 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, "Sheng-Hui J. Chu" <jeffchu@broadcom.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [003/104] i2c-algo-bit: Generate correct i2c address sequence for 10-bit target
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -486,7 +486,7 @@ static int bit_doAddress(struct i2c_adap
 
 	if (flags & I2C_M_TEN) {
 		/* a ten bit address */
-		addr = 0xf0 | ((msg->addr >> 7) & 0x03);
+		addr = 0xf0 | ((msg->addr >> 7) & 0x06);
 		bit_dbg(2, &i2c_adap->dev, "addr0: %d\n", addr);
 		/* try extended address code...*/
 		ret = try_address(i2c_adap, addr, retries);
@@ -496,7 +496,7 @@ static int bit_doAddress(struct i2c_adap
 			return -EREMOTEIO;
 		}
 		/* the remaining 8 bit address */
-		ret = i2c_outb(i2c_adap, msg->addr & 0x7f);
+		ret = i2c_outb(i2c_adap, msg->addr & 0xff);
 		if ((ret != 1) && !nak_ok) {
 			/* the chip did not ack / xmission error occurred */
 			dev_err(&i2c_adap->dev, "died at 2nd address code\n");


