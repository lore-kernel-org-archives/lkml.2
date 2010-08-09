Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0HIHtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:49:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39674 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIHty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=eIDpFNgTAvTNboNxgExAG1dfCP8VOLWipHUAqf4o8aflasLC4TDETeeHFMflZzBsV6
         NYL3PAOWC/0mUG9rcGXuGJZAhi8IRfs2Y+ABb62SB6Kwi/lcmb7eEGWjU55Y7CwVEZUA
         sChevXIzY3E1TyyZ0MubWeiC/Ua5qaSN7d6Zk=
Subject: [PATCH RESEND] regulator: tps6507x - add missing
	platform_set_drvdata in tps6507x_pmic_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 15:51:23 +0800
Message-Id: <1281340283.20518.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call platform_set_drvdata() before calling platform_get_drvdata().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Per Mark's comment, this resend remove platform_set_drvdata(pdev, NULL)
in tps6507x_pmic_remove.
 drivers/regulator/tps6507x-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 8152d65..c239f42 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -614,6 +614,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 	}
 
 	tps6507x_dev->pmic = tps;
+	platform_set_drvdata(pdev, tps6507x_dev);
 
 	return 0;
 
-- 
1.5.4.3



