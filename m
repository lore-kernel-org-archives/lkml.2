Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0HVH03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 03:26:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab0HVH01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 03:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jzSfZY6PRz3dT3TI+g4P2vgGukA8caatgiNoPWUSwrCRQJp7vLpWBueZO+qquzRjqg
         TRMfnfvudYwyJrTKGPjx6cX8uxlB29mA1RrfEncE4OfpU2hmwO0QjOcfSaEUuAWQ5h4o
         7Z+fCi9hm3xSMbaKU7BpgvKC2JTs0nIrxpvYg=
Subject: [PATCH] regulator: max8998 - set max8998->num_regulators
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 15:26:49 +0800
Message-ID: <1282462009.2989.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set max8998->num_regulators = pdata->num_regulators,
otherwise it's default value is 0.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index ab67298..f0d8261 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -558,6 +558,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 
 	rdev = max8998->rdev;
 	max8998->iodev = iodev;
+	max8998->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, max8998);
 
 	for (i = 0; i < pdata->num_regulators; i++) {
-- 
1.7.0.4



