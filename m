Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935375Ab1KJEx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:53:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935319Ab1KJDb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.700207636@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Durgadoss R <Durgadoss.r@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [210/262] hwmon: (coretemp) Fix for non-SMP builds
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 2aba6cac2a84f3b80e11a680c34d55e7739b474d upstream.

The definition of TO_ATTR_NO in the non-SMP case is wrong. As the SMP
definition resolves to the correct value, just use this for both
cases.

Without this fix the temperature attributes are named temp0_* instead
of temp2_*, so libsensors won't pick them. Broken since kernel 3.0.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Phil Sutter <phil@nwl.cc>
Acked-by: Durgadoss R <Durgadoss.r@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -50,14 +50,13 @@
 #ifdef CONFIG_SMP
 #define TO_PHYS_ID(cpu)		cpu_data(cpu).phys_proc_id
 #define TO_CORE_ID(cpu)		cpu_data(cpu).cpu_core_id
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 #define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
 #else
 #define TO_PHYS_ID(cpu)		(cpu)
 #define TO_CORE_ID(cpu)		(cpu)
-#define TO_ATTR_NO(cpu)		(cpu)
 #define for_each_sibling(i, cpu)	for (i = 0; false; )
 #endif
+#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 
 /*
  * Per-Core Temperature Data


