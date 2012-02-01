Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2BAVRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48506 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350Ab2BAVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:41 -0500
X-Sasl-enc: uwlbcx7qejnp0vfEM/BHTgXptMrzEA/VzCww2mphvErh 1328131060
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.630465177@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [65/89] hwmon: (sht15) fix bad error code
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit 6edf3c30af01854c416f8654d3d5d2652470afd4 upstream.

When no platform data was supplied, returned error code was 0.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/sht15.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -883,7 +883,7 @@ static int sht15_invalidate_voltage(stru
 
 static int __devinit sht15_probe(struct platform_device *pdev)
 {
-	int ret = 0;
+	int ret;
 	struct sht15_data *data = kzalloc(sizeof(*data), GFP_KERNEL);
 	u8 status = 0;
 
@@ -901,6 +901,7 @@ static int __devinit sht15_probe(struct
 	init_waitqueue_head(&data->wait_queue);
 
 	if (pdev->dev.platform_data == NULL) {
+		ret = -EINVAL;
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		goto err_free_data;
 	}


