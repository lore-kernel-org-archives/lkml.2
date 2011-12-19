Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1LSL4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:56:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1LSL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:56:22 -0500
Message-ID: <1324295757.3350.3.camel@phoenix>
Subject: [PATCH RESEND 1/3] mfd: Fix checking bit_mask for adp5520_set_bits
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org
Date: Mon, 19 Dec 2011 19:55:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code checks if all the bit_mask bits are all zero is wrong.
We need to write new value if old value is not equal to new value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
---
Hi Samuel,
I found this serial of patches are not merged yet. 
( although you replied that you applied all 3 patches in the mail )
It was post on https://lkml.org/lkml/2011/10/30/137
So I resend it again.

Thanks,
Axel
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



