Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2BAOne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:43:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:60806 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2BAOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:43:32 -0500
Date: Wed, 1 Feb 2012 17:42:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hwmon: (mc13xxx-adc) make name buffer larger
Message-ID: <20120201144231.GB5397@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F294F63.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is doesn't change how the code works, it's just a thing to make the
static checkers happy.  We transfer a 12 character string from a 20
character buffer to a 10 character buffer using snprintf().  The static
checkers complain that that lops off the last couple characters.

The static checkers are right, but it turns out we don't care because
later on we truncate the name at the '-' character.  Oh well, let's
change it so they don't complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index e9a7659d..282aaf5 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -37,7 +37,7 @@
 struct mc13783_adc_priv {
 	struct mc13xxx *mc13xxx;
 	struct device *hwmon_dev;
-	char name[10];
+	char name[PLATFORM_NAME_SIZE];
 };
 
 static ssize_t mc13783_adc_show_name(struct device *dev, struct device_attribute
