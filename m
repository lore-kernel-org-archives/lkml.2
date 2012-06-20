Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2FTSWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2FTSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:35 -0400
Message-Id: <20120620173023.769909913@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Zelenoff <antonz@parallels.com>
Subject: [ 33/61] USB: mos7840: Fix compilation of usb serial driver
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Zelenoff <antonz@parallels.com>

commit b9c87663eead64c767e72a373ae6f8a94bead459 upstream.

The __devinitconst section can't be referenced
from usb_serial_device structure. Thus removed it as
it done in other mos* device drivers.

Error itself:
WARNING: drivers/usb/serial/mos7840.o(.data+0x8): Section mismatch in reference
from the variable moschip7840_4port_device to the variable
.devinit.rodata:id_table
The variable moschip7840_4port_device references
the variable __devinitconst id_table

[v2] no attach now

Signed-off-by: Tony Zelenoff <antonz@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -206,7 +206,7 @@ static const struct usb_device_id moschi
 	{}			/* terminating entry */
 };
 
-static const struct usb_device_id moschip_id_table_combined[] __devinitconst = {
+static const struct usb_device_id moschip_id_table_combined[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},


