Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2BAVlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:41:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50023 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab2BAVJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:31 -0500
X-Sasl-enc: M3fONs51Km5SPVNmW3u3qVesCvc0h/BkuCVACDmfXNWa 1328130570
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.408963543@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [45/65] hwmon: (sht15) fix bad error code
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


