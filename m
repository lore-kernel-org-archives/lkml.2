Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0JNPcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:32:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37485 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab0JNPcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:32:18 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] oprofile: include platform_device.h to fix build break
Date: Thu, 14 Oct 2010 21:01:43 +0530
Message-Id: <1287070303-32404-2-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1287070303-32404-1-git-send-email-gadiyar@ti.com>
References: <1287070303-32404-1-git-send-email-gadiyar@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofile_perf.c needs to include platform_device.h
Otherwise we get the following build break.

  CC      arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.o
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:192: warning: 'struct platform_device' declared inside parameter list
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:192: warning: its scope is only this definition or declaration, which is probably not what you want
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:201: warning: 'struct platform_device' declared inside parameter list
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:210: error: variable 'oprofile_driver' has initializer but incomplete type
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: unknown field 'driver' specified in initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: extra brace group at end of initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:211: error: (near initialization for 'oprofile_driver')
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:213: warning: excess elements in struct initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:213: warning: (near initialization for 'oprofile_driver')
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: error: unknown field 'resume' specified in initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: warning: excess elements in struct initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:214: warning: (near initialization for 'oprofile_driver')
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: error: unknown field 'suspend' specified in initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: warning: excess elements in struct initializer
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c:215: warning: (near initialization for 'oprofile_driver')
arch/arm/oprofile/../../../drivers/oprofile/oprofile_perf.c: In function 'init_driverfs':

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <robert.richter@amd.com>
---
This build break was seen on linux-next as of 20101014, with
a custom config for OMAP4

 drivers/oprofile/oprofile_perf.c |    1 +
 1 file changed, 1 insertion(+)

Index: mainline/drivers/oprofile/oprofile_perf.c
===================================================================
--- mainline.orig/drivers/oprofile/oprofile_perf.c
+++ mainline/drivers/oprofile/oprofile_perf.c
@@ -4,6 +4,7 @@
  * Perf-events backend for OProfile.
  */
 #include <linux/perf_event.h>
+#include <linux/platform_device.h>
 #include <linux/oprofile.h>
 #include <linux/slab.h>
 
