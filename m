Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1IAI4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:56:22 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33183 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab1IAI4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:56:19 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E5F4AA0.2070006@cam.ac.uk>
Date: Thu, 01 Sep 2011 10:04:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Andrew Chew <AChew@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: [PATCH] staging:iio:magnetometer:ak8975 use platform_data to pass
 the gpio number.
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com> <4E5F49F4.2080208@cam.ac.uk>
In-Reply-To: <4E5F49F4.2080208@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically provide another means to set this value given irq_to_gpio has
gone away.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/magnetometer/ak8975.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index c1ff430..ab0e26c 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -477,7 +477,10 @@ static int ak8975_probe(struct i2c_client *client,
 	int err;
 
 	/* Grab and set up the supplied GPIO. */
-	eoc_gpio = -1; /* FIXME: irq_to_gpio(client->irq) */
+	if (client->dev.platform_data == NULL)
+		eoc_gpio = -1;
+	else
+		eoc_gpio = *(int *)(client->dev.platform_data);
 
 	/* We may not have a GPIO based IRQ to scan, that is fine, we will
 	   poll if so */
-- 
1.7.3.4

