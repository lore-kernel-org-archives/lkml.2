Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1IAWGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:06:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59047 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1IAWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:05:04 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 3/5] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
Date: Thu,  1 Sep 2011 16:04:34 -0600
Message-Id: <1314914676-28397-8-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
tegra_defconfig. This causes a build failure.

Instead, obtain the GPIO ID corresponding to the chip's IRQ from the new
i2c_client field irq_gpio.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/staging/iio/magnetometer/ak8975.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index a17fa9f..14076da 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -477,7 +477,7 @@ static int ak8975_probe(struct i2c_client *client,
 	int err;
 
 	/* Grab and set up the supplied GPIO. */
-	eoc_gpio = irq_to_gpio(client->irq);
+	eoc_gpio = client->irq_gpio;
 
 	/* We may not have a GPIO based IRQ to scan, that is fine, we will
 	   poll if so */
-- 
1.7.0.4

