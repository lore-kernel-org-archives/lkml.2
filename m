Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0KEHVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:21:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40973 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab0KEHVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WtL5I1TUQBDi/21flnfinn83Ge/Xm7G0b6VFIPHE7ANFIyfXjJ/rB6uKVqe9qap5Dj
         cdybRjHOIHYb3TsKwCXsTqhuI1rs4iTmK7Fw7l3jaE63IZGHlv6Zs7pEQ3fCrXRBHvRy
         acMrDtCTFMD8mpfVNZhYx10QFAQzY64bawV58=
Subject: [PATCH 1/3] regulator: Remove a redundant device_remove_file call
	in create_regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 05 Nov 2010 15:25:12 +0800
Message-Id: <1288941912.16201.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have device_remove_file() in error path,
no need to call it before goto link_name_err.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..5ee67ba 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1052,7 +1052,6 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 			printk(KERN_WARNING
 			       "%s: could not add device link %s err %d\n",
 			       __func__, dev->kobj.name, err);
-			device_remove_file(dev, &regulator->dev_attr);
 			goto link_name_err;
 		}
 	}
-- 
1.7.2



