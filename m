Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3AHXg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:63347 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3AHXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 20/77] i2c-algo-bit: Generate correct i2c address sequence for 10-bit target
Date: Tue, 8 Jan 2013 18:34:59 -0500
Message-ID: <1357688156-25387-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cc6bcf7d2ec2234e7b41770185e4dc826390185e upstream.

The wrong bits were put on the wire, fix that.

This fixes kernel bug #42562.

Signed-off-by: Sheng-Hui J. Chu <jeffchu@broadcom.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/algos/i2c-algo-bit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
index a39e6cf..4e1a332 100644
--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -470,7 +470,7 @@ static int bit_doAddress(struct i2c_adapter *i2c_adap, struct i2c_msg *msg)
 
 	if (flags & I2C_M_TEN) {
 		/* a ten bit address */
-		addr = 0xf0 | ((msg->addr >> 7) & 0x03);
+		addr = 0xf0 | ((msg->addr >> 7) & 0x06);
 		bit_dbg(2, &i2c_adap->dev, "addr0: %d\n", addr);
 		/* try extended address code...*/
 		ret = try_address(i2c_adap, addr, retries);
@@ -480,7 +480,7 @@ static int bit_doAddress(struct i2c_adapter *i2c_adap, struct i2c_msg *msg)
 			return -EREMOTEIO;
 		}
 		/* the remaining 8 bit address */
-		ret = i2c_outb(i2c_adap, msg->addr & 0x7f);
+		ret = i2c_outb(i2c_adap, msg->addr & 0xff);
 		if ((ret != 1) && !nak_ok) {
 			/* the chip did not ack / xmission error occurred */
 			dev_err(&i2c_adap->dev, "died at 2nd address code\n");
-- 
1.7.12.1

