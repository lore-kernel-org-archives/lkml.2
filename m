Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0KENvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:51:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45053 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0KENvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cnXRUgwVEAh8GFwMXrogRk83Pra5vq7gWZPOHZKDjq6wX0pzW6bjGF23VHw575qdHW
         +QfflzetqwBb5I6u4zoZixRNIvQgtNgcRj7yhNkLOiIK/d+v8JytZJBRY/agS1jEsDQB
         lIsjfq+YgHZcP6BzESKgTG4+AQBKvtmGQ/GOw=
Subject: [PATCH 2/3 v2] regulator: Ensure enough delay time for enabling
 regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 21:51:32 +0800
Message-ID: <1288965092.2312.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division will truncate the result, this patch ensures we have
enough delay time for enabling regulator.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5ee67ba..0ab5749 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1312,10 +1312,12 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (ret < 0)
 				return ret;
 
-			if (delay >= 1000)
+			if (delay >= 1000) {
 				mdelay(delay / 1000);
-			else if (delay)
+				udelay(delay % 1000);
+			} else if (delay) {
 				udelay(delay);
+			}
 
 		} else if (ret < 0) {
 			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
-- 
1.7.0.4



