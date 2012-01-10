Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab2AJW7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:59:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab2AJW7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:22 2012
Message-Id: <20120110215022.470150661@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Pete Zaitcev <zaitcev@redhat.com>
Subject: [18/42] USB: update documentation for usbmon
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d8cae98cddd286e38db1724dda1b0e7b467f9237 upstream.

The documentation for usbmon is out of date; the usbfs "devices" file
now exists in /sys/kernel/debug/usb rather than /proc/bus/usb.  This
patch (as1505) updates the documentation accordingly, and also
mentions that the necessary information can be found by running lsusb.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/usb/usbmon.txt |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -47,10 +47,11 @@ This allows to filter away annoying devi
 
 2. Find which bus connects to the desired device
 
-Run "cat /proc/bus/usb/devices", and find the T-line which corresponds to
-the device. Usually you do it by looking for the vendor string. If you have
-many similar devices, unplug one and compare two /proc/bus/usb/devices outputs.
-The T-line will have a bus number. Example:
+Run "cat /sys/kernel/debug/usb/devices", and find the T-line which corresponds
+to the device. Usually you do it by looking for the vendor string. If you have
+many similar devices, unplug one and compare the two
+/sys/kernel/debug/usb/devices outputs. The T-line will have a bus number.
+Example:
 
 T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
@@ -58,7 +59,10 @@ P:  Vendor=0557 ProdID=2004 Rev= 1.00
 S:  Manufacturer=ATEN
 S:  Product=UC100KM V2.00
 
-Bus=03 means it's bus 3.
+"Bus=03" means it's bus 3. Alternatively, you can look at the output from
+"lsusb" and get the bus number from the appropriate line. Example:
+
+Bus 003 Device 002: ID 0557:2004 ATEN UC100KM V2.00
 
 3. Start 'cat'
 


