Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0JTIzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:55:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57320 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JTIzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wX3D4kSaEg8/wPbMpJKlntmqEzK2k5pijoL17vraR4izwsxDITKuY3w3EETT8M3HQt
         CNl/1/pd+sxgdmGcevPq/GUvIokqm5FRplSE9hzlKW7h0DQpRGeOd3HCIoawyZku60Z0
         tZ2MP6QB5+1M6n4cV0I+zBr+3bTKQaEA/ZhhA=
Subject: [PATCH] mfd: Fix resource reclaim in pcf50633_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Harald Welte <laforge@openmoko.org>
Content-Type: text/plain
Date: Wed, 20 Oct 2010 16:56:59 +0800
Message-Id: <1287565019.7849.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling sysfs_remove_group() to remove sysfs entries
and unregister bl_pdev in pcf50633_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 6d4233f..501ce13 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -339,12 +339,14 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	struct pcf50633 *pcf = i2c_get_clientdata(client);
 	int i;
 
+	sysfs_remove_group(&client->dev.kobj, &pcf_attr_group);
 	pcf50633_irq_free(pcf);
 
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
 	platform_device_unregister(pcf->mbc_pdev);
 	platform_device_unregister(pcf->adc_pdev);
+	platform_device_unregister(pcf->bl_pdev);
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
 		platform_device_unregister(pcf->regulator_pdev[i]);
-- 
1.7.2



