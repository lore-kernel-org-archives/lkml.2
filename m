Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2KNFur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55154 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315Ab2KNFun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:43 -0500
Message-Id: <20121114053941.728271535@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 57/82] hwmon: (w83627ehf) Force initial bank selection
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 3300fb4f88688029fff8dfb9ec0734f6e4cba3e7 upstream.

Don't assume bank 0 is selected at device probe time. This may not be
the case. Force bank selection at first register access to guarantee
that we read the right registers upon driver loading.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/w83627ehf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 1821b74..de3c7e0 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -2083,6 +2083,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	mutex_init(&data->lock);
 	mutex_init(&data->update_lock);
 	data->name = w83627ehf_device_names[sio_data->kind];
+	data->bank = 0xff;		/* Force initial bank selection */
 	platform_set_drvdata(pdev, data);
 
 	/* 627EHG and 627EHF have 10 voltage inputs; 627DHG and 667HG have 9 */


