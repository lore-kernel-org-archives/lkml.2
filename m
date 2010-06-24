Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FXWGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 18:06:10 -0400
Received: from imr3.ericy.com ([198.24.6.13]:39699 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0FXWGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 18:06:06 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v3 3/4] hwmon: Update sysfs-interface to include new attributes
Date: Thu, 24 Jun 2010 15:01:00 -0700
Message-ID: <1277416861-32494-4-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added _lcrit and _crit to voltage attributes. 
Added _lcrit to temperature attributes.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/sysfs-interface |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index d4e2917..7f60c0d 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -107,10 +107,24 @@ in[0-*]_min	Voltage min value.
 		Unit: millivolt
 		RW
 		
+in[0-*]_lcrit	Voltage critical min value.
+		Unit: millivolt
+		RW
+		If voltage drops to or below this limit, the system may
+		take drastic action such as power down or reset. At the very
+		least, it should report a fault.
+
 in[0-*]_max	Voltage max value.
 		Unit: millivolt
 		RW
 		
+in[0-*]_crit	Voltage critical max value.
+		Unit: millivolt
+		RW
+		If voltage reaches or exceeds this limit, the system may
+		take drastic action such as power down or reset. At the very
+		least, it should report a fault.
+
 in[0-*]_input	Voltage input value.
 		Unit: millivolt
 		RO
@@ -284,11 +298,16 @@ temp[1-*]_input Temperature input value.
 		Unit: millidegree Celsius
 		RO
 
-temp[1-*]_crit	Temperature critical value, typically greater than
+temp[1-*]_crit	Temperature critical max value, typically greater than
 		corresponding temp_max values.
 		Unit: millidegree Celsius
 		RW
 
+temp[1-*]_lcrit	Temperature critical min value, typically lower than
+		corresponding temp_min values.
+		Unit: millidegree Celsius
+		RW
+
 temp[1-*]_crit_hyst
 		Temperature hysteresis value for critical limit.
 		Unit: millidegree Celsius
-- 
1.7.0.87.g0901d

