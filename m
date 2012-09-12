Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2ILMQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:16:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55027 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab2ILMQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:16:18 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 2/2] leds-lp5523: Fix riskiness of the page fault
Thread-Topic: [PATCH 2/2] leds-lp5523: Fix riskiness of the page fault
Thread-Index: Ac2Q4GCX4r5uCQNLSDuDdKt5Xckwog==
Date: Wed, 12 Sep 2012 12:16:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF49D3@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The last attribute should be terminated as NULL because any member of
 attribute structure is accessed while adding the sysfs file.
 If not, invalid address may cause the page fault problem.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5ebdc92..97994ff 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -759,6 +759,7 @@ static struct attribute *lp5523_attributes[] = {
 	&dev_attr_engine2_leds.attr,
 	&dev_attr_engine3_load.attr,
 	&dev_attr_engine3_leds.attr,
+	NULL,
 };
 
 static const struct attribute_group lp5523_group = {
-- 
1.7.9.5


Best Regards,
Milo


