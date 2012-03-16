Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946379Ab2CPXwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:52:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965492Ab2CPXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:25 -0400
Message-Id: <20120316233450.508704007@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 36/38] hwmon: (w83627ehf) Fix writing into fan_stop_time for NCT6775F/NCT6776F
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 33fa9b620409edfc71aa6cf01a51f990fbe46ab8 upstream.

NCT6775F and NCT6776F have their own set of registers for FAN_STOP_TIME. The
correct registers were used to read FAN_STOP_TIME, but writes used the wrong
registers. Fix it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83627ehf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1583,7 +1583,7 @@ store_##reg(struct device *dev, struct d
 	val = step_time_to_reg(val, data->pwm_mode[nr]); \
 	mutex_lock(&data->update_lock); \
 	data->reg[nr] = val; \
-	w83627ehf_write_value(data, W83627EHF_REG_##REG[nr], val); \
+	w83627ehf_write_value(data, data->REG_##REG[nr], val); \
 	mutex_unlock(&data->update_lock); \
 	return count; \
 } \


