Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1JaGXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:23:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1JaGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:23:14 -0400
Message-ID: <1320042183.5683.1.camel@phoenix>
Subject: [PATCH 1/2] mfd: da903x: Ensure setting bits if new value is
 different from the old value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 31 Oct 2011 14:23:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
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
 drivers/mfd/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 62ce685..1924b85 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -182,7 +182,7 @@ int da903x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 	if (ret)
 		goto out;
 
-	if ((reg_val & bit_mask) == 0) {
+	if ((reg_val & bit_mask) != bit_mask) {
 		reg_val |= bit_mask;
 		ret = __da903x_write(chip->client, reg, reg_val);
 	}
-- 
1.7.5.4



