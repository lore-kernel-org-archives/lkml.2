Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1HaTlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:41:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38096 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1HaTlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:41:19 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russell King <linux@arm.linux.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Andrew Chew <achew@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] staging:iio:magnetometer:ak8975: Fix probe() error-handling
Date: Wed, 31 Aug 2011 13:40:57 -0600
Message-Id: <1314819657-828-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314819657-828-1-git-send-email-swarren@nvidia.com>
References: <1314819657-828-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ak8975_probe() to jump to the appropriate exit labels when an error
occurs. With the previous code, some cleanup actions were being skipped
for some error conditions.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/staging/iio/magnetometer/ak8975.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 79ed183..d92b3d0 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -510,7 +510,7 @@ static int ak8975_probe(struct i2c_client *client,
 	err = ak8975_setup(client);
 	if (err < 0) {
 		dev_err(&client->dev, "AK8975 initialization fails\n");
-		goto exit_gpio;
+		goto exit_free_iio;
 	}
 
 	i2c_set_clientdata(client, indio_dev);
-- 
1.7.0.4

