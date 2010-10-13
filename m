Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0JMCnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 22:43:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43496 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0JMCnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 22:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gEjBHEDWbWX1c2nw7HpRmJKK+23rjfs1Mfr00nF6FG4TrSstTBtx/9TdQzJxUHCktj
         JW7sA4AkhRlwvf+6WSk9w/uf9CXS9OG8HslbUJKA/qprO09cPSTnkZRLqrJNRhS2EVGo
         VSgE/BeXjbEvZwhMurcV8y+rZZmCZzx4AOpFM=
Subject: [PATCH] mfd: tps6507x - fix off-by-one value range checking
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Todd Fischer <todd.fischer@ridgerun.com>
Content-Type: text/plain
Date: Wed, 13 Oct 2010 10:44:39 +0800
Message-Id: <1286937879.453.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use msg[0] for device register.
If bytes == (TPS6507X_MAX_REGISTER + 1),
we got a buffer overflow when doing memcpy(&msg[1], src, bytes);
Thus we must ensure bytes not greater than TPS6507X_MAX_REGISTER.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps6507x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index fc01976..33ba772 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -68,7 +68,7 @@ static int tps6507x_i2c_write_device(struct tps6507x_dev *tps6507x, char reg,
 	u8 msg[TPS6507X_MAX_REGISTER + 1];
 	int ret;
 
-	if (bytes > (TPS6507X_MAX_REGISTER + 1))
+	if (bytes > TPS6507X_MAX_REGISTER)
 		return -EINVAL;
 
 	msg[0] = reg;
-- 
1.7.2



