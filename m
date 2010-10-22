Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0JVAkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:40:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41451 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab0JVAkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=e1foL6YjZGJJ3jn6eq+a2oSGObyp817aPfTJg+cmiass1fLsQzGS3N2N739TpalyPg
         zvdF3G1vQMIJGjJWzyA7Dnx9j5YrjLn1BZ+q8MbQf13KgOEqMttmmCFBGRnnlLxHApnM
         IcCs7ZZPPKG2om1DyzfskjXOwrzXMriytKnRI=
Subject: [PATCH] mfd: Fix a memory leak when unload mc13xxx-core module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 08:42:26 +0800
Message-Id: <1287708146.27802.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mc13xxx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 1326e7f..f397329 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -792,8 +792,8 @@ static int __devexit mc13xxx_remove(struct spi_device *spi)
 	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
 
 	free_irq(mc13xxx->spidev->irq, mc13xxx);
-
 	mfd_remove_devices(&spi->dev);
+	kfree(mc13xxx);
 
 	return 0;
 }
-- 
1.7.2



