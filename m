Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0IUIaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:30:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53895 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab0IUIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fW6V0t5/6Tu3xLyd0JmZCbKHOcUpvH6tbkfh9GGbku1aktE0oxx0j3SMPOX8r9sJEP
         tQDmLfeRl7JLWqDlzx0AdQOiH6uBHRubKjOC88SZc+U4hfB3R4YFu+5lU8tGXRNCps+K
         WcW521vzDZ3bT/IU4/3znbdJmCCTLHdPsc0Fc=
Subject: [PATCH] drivers/power: add missing sysfs_remove_group() in
	pcf50633_mbc_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Balaji Rao <balajirrao@openmoko.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain
Date: Tue, 21 Sep 2010 16:35:57 +0800
Message-Id: <1285058157.26315.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs entries should be removed when unload the module.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/pcf50633-charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 066f994..4fa52e1 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -456,6 +456,7 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
 		pcf50633_free_irq(mbc->pcf, mbc_irq_handlers[i]);
 
+	sysfs_remove_group(&pdev->dev.kobj, &mbc_attr_group);
 	power_supply_unregister(&mbc->usb);
 	power_supply_unregister(&mbc->adapter);
 	power_supply_unregister(&mbc->ac);
-- 
1.7.2



