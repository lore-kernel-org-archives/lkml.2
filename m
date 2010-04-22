Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0DVUAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:00:49 -0400
Received: from kroah.org ([198.145.64.141]:59765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015Ab0DVUAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.275328115@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [065/139] hwmon: (sht15) Properly handle the case CONFIG_REGULATOR=n
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit c7a78d2c2e2537fd24903e966f34aae50319d587 upstream.

When CONFIG_REGULATOR isn't set, regulator_get_voltage() returns 0.
Properly handle this case by not trusting the value.

Reported-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/sht15.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -541,7 +541,12 @@ static int __devinit sht15_probe(struct
 /* If a regulator is available, query what the supply voltage actually is!*/
 	data->reg = regulator_get(data->dev, "vcc");
 	if (!IS_ERR(data->reg)) {
-		data->supply_uV = regulator_get_voltage(data->reg);
+		int voltage;
+
+		voltage = regulator_get_voltage(data->reg);
+		if (voltage)
+			data->supply_uV = voltage;
+
 		regulator_enable(data->reg);
 		/* setup a notifier block to update this if another device
 		 *  causes the voltage to change */


