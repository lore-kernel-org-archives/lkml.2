Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2CIUO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:14:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031128Ab2CITtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:49 -0500
Message-Id: <20120309190208.441081880@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michele Petracca <mi.petracca@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 76/95] hwmon: (pmbus_core) Fix maximum number of POUT alarm attributes
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 7cb3c44fb1f7999e4c53b6a52de6bc25da6de079 upstream.

There are up to three POUT alarm attributes, not two, since cap_alarm was added.

Reported-by: Michele Petracca <mi.petracca@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/pmbus_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -54,7 +54,8 @@
 						   lcrit_alarm, crit_alarm */
 #define PMBUS_IOUT_BOOLEANS_PER_PAGE	3	/* alarm, lcrit_alarm,
 						   crit_alarm */
-#define PMBUS_POUT_BOOLEANS_PER_PAGE	2	/* alarm, crit_alarm */
+#define PMBUS_POUT_BOOLEANS_PER_PAGE	3	/* cap_alarm, alarm, crit_alarm
+						 */
 #define PMBUS_MAX_BOOLEANS_PER_FAN	2	/* alarm, fault */
 #define PMBUS_MAX_BOOLEANS_PER_TEMP	4	/* min_alarm, max_alarm,
 						   lcrit_alarm, crit_alarm */


