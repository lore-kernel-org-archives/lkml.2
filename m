Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0IDPGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:06:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51707 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0IDPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=e57j2JNZglET2H1s6smimjVQJoaNA1FssUk1z4NMKREIOxIPk0PyGhGlOXQnfOfkEL
         heoOgqiZoqhWB0Ii2Znnj4X9iBOUN2EgYrIeWr0o0ihuqPSbnVC4eVSCXQDPykLKt7Hr
         q6p/QC1/vvYDfVNbPs9oy4V3yQeNChBILumNk=
Subject: [PATCH] regulator: ab8500 - fix off-by-one value range checking
 for selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 23:06:41 +0800
Message-ID: <1283612801.2430.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

selector is used as array index of info->supported_voltages
Thus the valid value range should be 0 .. info->voltages_len -1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3d09580..28c7ae6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -157,7 +157,7 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 	if (info->fixed_uV)
 		return info->fixed_uV;
 
-	if (selector > info->voltages_len)
+	if (selector >= info->voltages_len)
 		return -EINVAL;
 
 	return info->supported_voltages[selector];
-- 
1.7.2



