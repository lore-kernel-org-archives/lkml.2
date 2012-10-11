Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab2JKNj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:39:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42070 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2JKNjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:39:55 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-pm@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kevin Hilman <khilman@ti.com>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] PM / OPP: Export symbols for module usage.
Date: Thu, 11 Oct 2012 08:39:34 -0500
Message-ID: <1349962774-19636-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liam Girdwood <lrg@ti.com>

Export the OPP functions for use by driver modules.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[nm@ti.com: expansion of functions exported]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Liam Girdwood <lrg@ti.com>
---
 drivers/base/power/opp.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index ac993ea..04d443f 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -22,6 +22,7 @@
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/opp.h>
+#include <linux/export.h>
 
 /*
  * Internal data structure organization with the OPP layer library is as
@@ -159,6 +160,7 @@ unsigned long opp_get_voltage(struct opp *opp)
 
 	return v;
 }
+EXPORT_SYMBOL(opp_get_voltage);
 
 /**
  * opp_get_freq() - Gets the frequency corresponding to an available opp
@@ -188,6 +190,7 @@ unsigned long opp_get_freq(struct opp *opp)
 
 	return f;
 }
+EXPORT_SYMBOL(opp_get_freq);
 
 /**
  * opp_get_opp_count() - Get number of opps available in the opp list
@@ -220,6 +223,7 @@ int opp_get_opp_count(struct device *dev)
 
 	return count;
 }
+EXPORT_SYMBOL(opp_get_opp_count);
 
 /**
  * opp_find_freq_exact() - search for an exact frequency
@@ -267,6 +271,7 @@ struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
 
 	return opp;
 }
+EXPORT_SYMBOL(opp_find_freq_exact);
 
 /**
  * opp_find_freq_ceil() - Search for an rounded ceil freq
@@ -309,6 +314,7 @@ struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
+EXPORT_SYMBOL(opp_find_freq_ceil);
 
 /**
  * opp_find_freq_floor() - Search for a rounded floor freq
@@ -355,6 +361,7 @@ struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
+EXPORT_SYMBOL(opp_find_freq_floor);
 
 /**
  * opp_add()  - Add an OPP table from a table definitions
@@ -551,6 +558,7 @@ int opp_enable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, true);
 }
+EXPORT_SYMBOL(opp_enable);
 
 /**
  * opp_disable() - Disable a specific OPP
@@ -572,6 +580,7 @@ int opp_disable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, false);
 }
+EXPORT_SYMBOL(opp_disable);
 
 #ifdef CONFIG_CPU_FREQ
 /**
-- 
1.7.9.5

