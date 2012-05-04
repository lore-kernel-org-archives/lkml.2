Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab2EDUuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:50:00 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:38140 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759995Ab2EDUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:53 -0400
Message-Id: <20120504204248.134080496@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Durgadoss R <durgadoss.r@intel.com>
Subject: [ 38/47] hwmon: (coretemp) Increase CPU core limit
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit bdc71c9a87b898e4c380c23b2e3e18071312ecde upstream.

CPU core ID is used to index the core_data[] array. The core ID is, however, not
sequential; 10-core CPUS can have a core ID as high as 25. Increase the limit to
32 to be able to deal with current CPUs.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/coretemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -42,7 +42,7 @@
 #define DRVNAME	"coretemp"
 
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		16	/* Number of Real cores per cpu */
+#define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
 #define MAX_ATTRS		5	/* Maximum no of per-core attrs */
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)


