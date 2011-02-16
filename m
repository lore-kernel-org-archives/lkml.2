Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1BPNBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:01:04 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34849 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598Ab1BPNBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:01:01 -0500
X-Sasl-enc: IrS/SsIhIe1REMyobn9lj/H17LbwobCSTQXQ/jzJ/iqQ 1297861260
Message-ID: <4D5BCABD.1060106@ladisch.de>
Date: Wed, 16 Feb 2011 14:01:49 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] hwmon: (jc42) fix type mismatch
References: <4D5BCA87.7010204@ladisch.de>
In-Reply-To: <4D5BCA87.7010204@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In set_temp_crit_hyst(), make the variable 'val' have the correct
type for strict_strtoul().

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/hwmon/jc42.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -332,7 +332,7 @@ static ssize_t set_temp_crit_hyst(struct
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct jc42_data *data = i2c_get_clientdata(client);
-	long val;
+	unsigned long val;
 	int diff, hyst;
 	int err;
 	int ret = count;
