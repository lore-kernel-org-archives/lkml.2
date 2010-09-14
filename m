Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0INCwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:52:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:21791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0INCwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,361,1280732400"; 
   d="scan'208";a="837374959"
Date: Tue, 14 Sep 2010 10:33:51 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>, Alan Cox <alan@linux.intel.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon/emc1403: remove unnecessary hwmon_device_unregister
Message-ID: <20100914023351.GA27145@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessary to call hwmon_device_unregister in error handling
before hwmon_device_register is called.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/hwmon/emc1403.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 5b58b20..8dee3f3 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -308,7 +308,6 @@ static int emc1403_probe(struct i2c_client *client,
 	res = sysfs_create_group(&client->dev.kobj, &m_thermal_gr);
 	if (res) {
 		dev_warn(&client->dev, "create group failed\n");
-		hwmon_device_unregister(data->hwmon_dev);
 		goto thermal_error1;
 	}
 	data->hwmon_dev = hwmon_device_register(&client->dev);
-- 
1.5.5.1

