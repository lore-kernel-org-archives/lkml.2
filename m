Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2IMSZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:25:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:42874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2IMSZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="192447935"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: Axel Lin <axel.lin@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] HID: hid-sensor-hub: Fix sensor_hub_probe error
 handling
Thread-Topic: [PATCH 2/2] HID: hid-sensor-hub: Fix sensor_hub_probe error
 handling
Thread-Index: AQHNkVCuNGdjxbdkZEi/yzCYW1fkNZeIl0/w
Date: Thu, 13 Sep 2012 18:24:58 +0000
Message-ID: <4FA419E87744DF4DAECD5BCE1214B7A919D52336@ORSMSX108.amr.corp.intel.com>
References: <1347500288.7434.1.camel@phoenix>
 <1347500387.7434.3.camel@phoenix>
In-Reply-To: <1347500387.7434.3.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8DIPA6U006296

Agreed. It works.

Thanks,
Srinivas

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Wednesday, September 12, 2012 6:40 PM
To: Jiri Kosina
Cc: Pandruvada, Srinivas; Jonathan Cameron; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: hid-sensor-hub: Fix sensor_hub_probe error handling

Fix below issues in sensor_hub_probe error handling:
1. In the case of goto err_close, hid_hw_stop(hdev) is called twice. Fix it.
2. If fails to allocate MFD device name, we also need to free all
   successfully allocated names in previous iterations.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-sensor-hub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c index 50bc8c7..8bd7620 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -584,7 +584,7 @@ static int sensor_hub_probe(struct hid_device *hdev,
 				hid_err(hdev,
 					"Failed MFD device name\n");
 					ret = -ENOMEM;
-					goto err_free_cells;
+					goto err_free_names;
 			}
 			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].name = name; @@ -608,10 +608,8 @@ static int sensor_hub_probe(struct hid_device *hdev,
 err_free_names:
 	for (i = 0; i < sd->hid_sensor_client_cnt ; ++i)
 		kfree(sd->hid_sensor_hub_client_devs[i].name);
-err_free_cells:
 	kfree(sd->hid_sensor_hub_client_devs);
 err_close:
-	hid_hw_stop(hdev);
 	hid_hw_close(hdev);
 err_stop_hw:
 	hid_hw_stop(hdev);
--
1.7.9.5



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
