Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2AMIPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:15:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42787 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2AMIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:15:35 -0500
Message-ID: <1326442521.5482.1.camel@phoenix>
Subject: [PATCH] backlight: Fix the logic to set bits in adp8860_bl and
 adp8870_bl drivers
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        device-drivers-devel@blackfin.uclinux.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 13 Jan 2012 16:15:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to write new value if the bit mask fields of new value is not equal to
old value. It does not make sense to write new value only when all the bit_mask
bits are zero.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/adp8860_bl.c |    2 +-
 drivers/video/backlight/adp8870_bl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 66bc74d..378276c 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -146,7 +146,7 @@ static int adp8860_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
 
 	ret = adp8860_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8860_write(client, reg, reg_val);
 	}
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 6c68a68..6735059 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -160,7 +160,7 @@ static int adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
 
 	ret = adp8870_read(client, reg, &reg_val);
 
-	if (!ret && ((reg_val & bit_mask) == 0)) {
+	if (!ret && ((reg_val & bit_mask) != bit_mask)) {
 		reg_val |= bit_mask;
 		ret = adp8870_write(client, reg, reg_val);
 	}
-- 
1.7.5.4



