Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab1C3WHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:07:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:4823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab1C3VGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733873"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, devzero@web.de,
        craig@nadler.us, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [23/275] USB: g_printer: fix bug in module parameter definitions
Message-Id: <20110330210417.DF8E43E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit ad84e4a9efb7c8ed322bafb6ebdb9c3a49a3d3a8 upstream.

This patch (as1442) fixes a bug in g_printer: Module parameters should
not be marked "__initdata" if they are accessible in sysfs (i.e., if
the mode value in the module_param() macro is nonzero).  Otherwise
attempts to access the parameters will cause addressing violations.

Character-string module parameters must not be marked "__initdata"
if the module can be unloaded, because the kernel needs to access the
parameter variable at unload time in order to free the
dynamically-allocated string.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Roland Kletzing <devzero@web.de>
CC: Craig W. Nadler <craig@nadler.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/printer.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/usb/gadget/printer.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/gadget/printer.c	2011-03-29 22:51:58.997213578 -0700
+++ linux-2.6.35.y/drivers/usb/gadget/printer.c	2011-03-29 23:02:58.690333681 -0700
@@ -130,31 +130,31 @@
  * parameters are in UTF-8 (superset of ASCII's 7 bit characters).
  */
 
-static ushort __initdata idVendor;
+static ushort idVendor;
 module_param(idVendor, ushort, S_IRUGO);
 MODULE_PARM_DESC(idVendor, "USB Vendor ID");
 
-static ushort __initdata idProduct;
+static ushort idProduct;
 module_param(idProduct, ushort, S_IRUGO);
 MODULE_PARM_DESC(idProduct, "USB Product ID");
 
-static ushort __initdata bcdDevice;
+static ushort bcdDevice;
 module_param(bcdDevice, ushort, S_IRUGO);
 MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");
 
-static char *__initdata iManufacturer;
+static char *iManufacturer;
 module_param(iManufacturer, charp, S_IRUGO);
 MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");
 
-static char *__initdata iProduct;
+static char *iProduct;
 module_param(iProduct, charp, S_IRUGO);
 MODULE_PARM_DESC(iProduct, "USB Product string");
 
-static char *__initdata iSerialNum;
+static char *iSerialNum;
 module_param(iSerialNum, charp, S_IRUGO);
 MODULE_PARM_DESC(iSerialNum, "1");
 
-static char *__initdata iPNPstring;
+static char *iPNPstring;
 module_param(iPNPstring, charp, S_IRUGO);
 MODULE_PARM_DESC(iPNPstring, "MFG:linux;MDL:g_printer;CLS:PRINTER;SN:1;");
 
