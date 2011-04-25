Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1DYVBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:01:36 -0400
Received: from 1wt.eu ([62.212.114.60]:33738 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab1DYUXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:23 -0400
Message-Id: <20110425200233.300486781@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland Kletzing <devzero@web.de>,
        "Craig W. Nadler" <craig@nadler.us>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 007/173] USB: g_printer: fix bug in module parameter definitions
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
CC: Roland Kletzing <devzero@web.de>
CC: Craig W. Nadler <craig@nadler.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/printer.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -130,31 +130,31 @@ static struct printer_dev usb_printer_ga
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
 


