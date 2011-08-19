Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1HSPYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:24:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HSPYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:24:15 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
CC: Anand Gadiyar <gadiyar@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH linux-next] mfd: omap-usb-host: add module.h and export.h to fix build break
Date: Fri, 19 Aug 2011 20:54:05 +0530
Message-ID: <1313767445-20033-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next as of 20110817 fails to build if these two headers
are not included. Including module.h is sufficient for now,
but add export.h for EXPORT_SYMBOL and THIS_MODULE in advance
to avoid a later build break.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Noticed this while testing another patch. I see similar
changes to other files in drivers/mfd made by Paul recently.

 drivers/mfd/omap-usb-host.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/mfd/omap-usb-host.c
===================================================================
--- linux-2.6.orig/drivers/mfd/omap-usb-host.c
+++ linux-2.6/drivers/mfd/omap-usb-host.c
@@ -20,6 +20,8 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
