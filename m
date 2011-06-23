Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1FWCRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:17:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62762 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1FWCRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AYne+dBgKyQ/BSR1eB78ju36w/DJ9sVMJ1BjRQLhONLRzxVA/+dybEFDFIJp11m/3c
         +nNdz7O+SJjCQMixEXJw1RqCE67kJ98KJ1LkW5qdJu/aKvLd4T+FECqRiU3/voXN4Fdc
         jLtSJ6UKmt1k2JQm9kUINNhZnYsHNh9XZFmrs=
Subject: [PATCH 2/3] mfd: Fix build error for tps65911-comparator.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1308795351.15248.2.camel@phoenix>
References: <1308795351.15248.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 10:17:43 +0800
Message-ID: <1308795463.15248.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:
  CC      drivers/mfd/tps65911-comparator.o
drivers/mfd/tps65911-comparator.c: In function 'tps65911_comparator_probe':
drivers/mfd/tps65911-comparator.c:131: error: 'struct tps65910_platform_data' has no member named 'vmbch_threshold'
drivers/mfd/tps65911-comparator.c:137: error: 'struct tps65910_platform_data' has no member named 'vmbch2_threshold'
make[2]: *** [drivers/mfd/tps65911-comparator.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65911-comparator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index 3d2dc56..283ac67 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -125,7 +125,7 @@ static DEVICE_ATTR(comp2_threshold, S_IRUGO, comp_threshold_show, NULL);
 static __devinit int tps65911_comparator_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
-	struct tps65910_platform_data *pdata = dev_get_platdata(tps65910->dev);
+	struct tps65910_board *pdata = dev_get_platdata(tps65910->dev);
 	int ret;
 
 	ret = comp_threshold_set(tps65910, COMP1,  pdata->vmbch_threshold);
-- 
1.7.4.1



