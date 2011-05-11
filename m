Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1EKQWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:22:37 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:61272 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1EKQWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PnY1XXgFlzObMM7yO5I+nktZ5EW9hK47jj6wNuKggem4GbDsaPtx4Y+VY9mEJAolpo
         Iw0BuNmr0A2YoeS9O6KEumkS0hKidjN4w61UcA5mUDNMTXUQpf8Tv/B+kNumfmyNxf8v
         W3Xi2HElakWlHRZy6YqjppGOFLp5tIBBMXyko=
Subject: [PATCH 1/2] spi: spi_sh: calling spi_unregister_master instead of
 spi_master_put in spi_sh_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 21:27:00 +0800
Message-ID: <1305120420.6324.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_master_put() should only be used in error handling.
Once spi_register_master() returns success, we should call
spi_unregister_master() instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi_sh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_sh.c b/drivers/spi/spi_sh.c
index 869a07d..9eedd71 100644
--- a/drivers/spi/spi_sh.c
+++ b/drivers/spi/spi_sh.c
@@ -427,10 +427,10 @@ static int __devexit spi_sh_remove(struct platform_device *pdev)
 {
 	struct spi_sh_data *ss = dev_get_drvdata(&pdev->dev);
 
+	spi_unregister_master(ss->master);
 	destroy_workqueue(ss->workqueue);
 	free_irq(ss->irq, ss);
 	iounmap(ss->addr);
-	spi_master_put(ss->master);
 
 	return 0;
 }
-- 
1.7.1



