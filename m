Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936619Ab2C3Wsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:48:51 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935027Ab2C3VGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:21 -0400
Message-Id: <201203302105.q2UL59oM006311@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:21:17 -0400
Subject: [PATCH] arch/tile: allow querying cpu module information from the hypervisor
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:10.0491 (UTC) FILETIME=[CAECF2B0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just adds a few more attributes to the information Linux
can query from the hypervisor for the /sys/hypervisor/board/ directory,
providing part, serial#, revision#, and description for cpu modules
(as opposed to the board itself, or any mezzanine boards).

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/hypervisor.h |   14 +++++++++++++-
 arch/tile/kernel/sysfs.c          |    8 ++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 3bc4045..5ae7faa 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -508,7 +508,19 @@ typedef enum {
   HV_CONFSTR_SWITCH_CONTROL  = 14,
 
   /** Chip revision level. */
-  HV_CONFSTR_CHIP_REV        = 15
+  HV_CONFSTR_CHIP_REV        = 15,
+
+  /** CPU module part number. */
+  HV_CONFSTR_CPUMOD_PART_NUM = 16,
+
+  /** CPU module serial number. */
+  HV_CONFSTR_CPUMOD_SERIAL_NUM = 17,
+
+  /** CPU module revision level. */
+  HV_CONFSTR_CPUMOD_REV      = 18,
+
+  /** Human-readable CPU module description. */
+  HV_CONFSTR_CPUMOD_DESC     = 19
 
 } HV_ConfstrQuery;
 
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index 71ae728..e25b0a8 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -93,6 +93,10 @@ HV_CONF_ATTR(mezz_part,		HV_CONFSTR_MEZZ_PART_NUM)
 HV_CONF_ATTR(mezz_serial,	HV_CONFSTR_MEZZ_SERIAL_NUM)
 HV_CONF_ATTR(mezz_revision,	HV_CONFSTR_MEZZ_REV)
 HV_CONF_ATTR(mezz_description,	HV_CONFSTR_MEZZ_DESC)
+HV_CONF_ATTR(cpumod_part,	HV_CONFSTR_CPUMOD_PART_NUM)
+HV_CONF_ATTR(cpumod_serial,	HV_CONFSTR_CPUMOD_SERIAL_NUM)
+HV_CONF_ATTR(cpumod_revision,	HV_CONFSTR_CPUMOD_REV)
+HV_CONF_ATTR(cpumod_description,HV_CONFSTR_CPUMOD_DESC)
 HV_CONF_ATTR(switch_control,	HV_CONFSTR_SWITCH_CONTROL)
 
 static struct attribute *board_attrs[] = {
@@ -104,6 +108,10 @@ static struct attribute *board_attrs[] = {
 	&dev_attr_mezz_serial.attr,
 	&dev_attr_mezz_revision.attr,
 	&dev_attr_mezz_description.attr,
+	&dev_attr_cpumod_part.attr,
+	&dev_attr_cpumod_serial.attr,
+	&dev_attr_cpumod_revision.attr,
+	&dev_attr_cpumod_description.attr,
 	&dev_attr_switch_control.attr,
 	NULL
 };
-- 
1.6.5.2

