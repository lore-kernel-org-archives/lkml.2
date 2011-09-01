Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1IAQxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:53:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33715 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1IAQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:53:10 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/4] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
Date: Thu,  1 Sep 2011 10:52:42 -0600
Message-Id: <1314895964-15964-6-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
tegra_defconfig. This causes a build failure.

Instead, obtain the GPIO ID corresponding to the chip's IRQ from the new
i2c_client field irq_gpio.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Obtain eoc_gpio from i2c_client, instead of hard-coding it as an
invalid value.

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

