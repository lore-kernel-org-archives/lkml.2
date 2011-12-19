Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1LSL7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:59:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63503 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1LSL7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:59:37 -0500
Message-ID: <1324295971.3350.6.camel@phoenix>
Subject: [PATCH RESEND 3/3] mfd: tps6586x: Ensure setting bits if new value
 is different from the old value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 19 Dec 2011 19:59:31 +0800
In-Reply-To: <1324295757.3350.3.camel@phoenix>
References: <1324295757.3350.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to write new value only when all the bit_mask
bits are zero.
We need to write new value if the bit mask fields of new value is
not equal to old value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index bba26d9..a5ddf31 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -197,7 +197,7 @@ int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 	if (ret)
 		goto out;
 
-	if ((reg_val & bit_mask) == 0) {
+	if ((reg_val & bit_mask) != bit_mask) {
 		reg_val |= bit_mask;
 		ret = __tps6586x_write(to_i2c_client(dev), reg, reg_val);
 	}
-- 
1.7.5.4



