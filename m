Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1FWRWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:62969 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab1FWRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 017/247] USB: g_printer: fix bug in module parameter definitions
Date: Thu, 23 Jun 2011 13:17:40 -0400
Message-Id: <1308849690-14530-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/gadget/printer.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 6b8bf8c..31fdfef 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -130,31 +130,31 @@ static struct printer_dev usb_printer_gadget;
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
 
-- 
1.7.4.4

