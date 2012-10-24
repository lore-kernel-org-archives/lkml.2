Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2JXHxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:53:24 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:34823 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2JXHxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:53:09 -0400
X-Greylist: delayed 2417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 03:53:09 EDT
Date: Wed, 24 Oct 2012 10:12:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] ds2782_battery: signedness bug in ds278x_read_reg16()
Message-ID: <20121024071229.GB2536@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check for negative values before doing the swab16() for the
error handling to work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 6bb6e2f..2fa9b6b 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -80,13 +80,13 @@ static inline int ds278x_read_reg16(struct ds278x_info *info, int reg_msb,
 {
 	int ret;
 
-	ret = swab16(i2c_smbus_read_word_data(info->client, reg_msb));
+	ret = i2c_smbus_read_word_data(info->client, reg_msb);
 	if (ret < 0) {
 		dev_err(&info->client->dev, "register read failed\n");
 		return ret;
 	}
 
-	*val = ret;
+	*val = swab16(ret);
 	return 0;
 }
 
