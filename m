Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab1FXOiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:38:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48614 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab1FXOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Zu/DFMSBpCNQC/snaL3sKHRKxjgAtAmkpCQ2wPRsMl/8Viuy4+FbK01X5yzy2qXX/p
         XZJhjJHeAyc7wMycoR4bHbP0d5dJejO/wpw2NODRUOLSKpNt+iT+tpcbR3Dv2z5IVF3A
         Z/ol0F/FkdKDmBIPXW62Xt3xDL9vRNuHd6qHI=
Subject: [PATCH] mfd: Fix off-by-one value range checking for
 tps65912_i2c_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 22:37:57 +0800
Message-ID: <1308926277.2628.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c5124060f13296bfc8cbbbb8298cf4b9b1faa1e9 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 24 Jun 2011 15:34:16 +0800
Subject: [PATCH] mfd: Fix off-by-one value range checking for tps65912_i2c_write

If bytes == (TPS6591X_MAX_REGISTER + 1), we have a buffer overflow when
doing memcpy(&msg[1], src, bytes).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65912-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65912-i2c.c b/drivers/mfd/tps65912-i2c.c
index 9ed123a..c041f2c 100644
--- a/drivers/mfd/tps65912-i2c.c
+++ b/drivers/mfd/tps65912-i2c.c
@@ -57,7 +57,7 @@ static int tps65912_i2c_write(struct tps65912 *tps65912, u8 reg,
 	u8 msg[TPS6591X_MAX_REGISTER + 1];
 	int ret;
 
-	if (bytes > (TPS6591X_MAX_REGISTER + 1))
+	if (bytes > TPS6591X_MAX_REGISTER)
 		return -EINVAL;
 
 	msg[0] = reg;
-- 
1.7.4.1



