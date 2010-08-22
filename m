Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab0HVOhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 10:37:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41952 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0HVOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 10:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WtqvVoRO0PPPu+35GXGbTZ/HBYPKfQSy/rMzkYXl3zzHDuiWYcZyA4KH7Df1LVAFGc
         08QM9fTcr5TRkYzFHQjlS2R+2wVkkQEaJ/rgKC1GzKQo0cu8yWKu//uUQ34Do1mki+Jx
         ltPJXlzMZJ7wiAtILlL9AR8EooDzBVf9na5n0=
Subject: [PATCH 1/2] regulator: tps6586x-regulator - fix value range
 checking for val
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 22:38:15 +0800
Message-ID: <1282487895.23014.19.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val is used as array index of ri->voltages.
Thus the valid value range should be 0 .. ri->desc.n_voltages - 1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 8cff141..facd439 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -133,7 +133,7 @@ static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
 	mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
 	val = (val & mask) >> ri->volt_shift;
 
-	if (val > ri->desc.n_voltages)
+	if (val >= ri->desc.n_voltages)
 		BUG();
 
 	return ri->voltages[val] * 1000;
-- 
1.7.0.4



