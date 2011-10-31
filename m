Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1JaDAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:00:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40500 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1JaDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:00:14 -0400
Message-ID: <1320030006.2690.8.camel@phoenix>
Subject: [PATCH] mfd: adp5520: Ensure setting bits if new value is different
 from the old value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org
Date: Mon, 31 Oct 2011 11:00:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code checks if all the bit_mask bits are all zero is wrong.
We need to write new value if the bit mask fields of new value is
not equal to old value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/adp5520.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index f1d8848..8d816cc 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -109,7 +109,7 @@ int adp5520_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 
 	ret = __adp5520_read(chip->client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = __adp5520_write(chip->client, reg, reg_val);
 	}
-- 
1.7.5.4



