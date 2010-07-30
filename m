Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab0G3ReY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:24 -0400
Received: from kroah.org ([198.145.64.141]:35428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301Ab0G3Rdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:03 2010
Message-Id: <20100730173103.350122686@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tadashi Abe <tabe@mvista.com>, "David S. Miller" <davem@davemloft.net>
Subject: [006/140] pegasus: fix USB device ID for ETX-US2
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tadashi Abe <tabe@mvista.com>

[ Upstream commit 95718c1c25370b2c85061a4d8dfab2831b3ad280 ]

USB device ID definition for I-O Data ETX-US2 is wrong.
Correct ID is 0x093a. Here's snippet from /proc/bus/usb/devices;

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04bb ProdID=093a Rev= 1.01
S:  Manufacturer=I-O DATA DEVICE,INC.
S:  Product=I-O DATA ETX2-US2
S:  SerialNumber=A26427
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=224mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=00 Driver=pegasus
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=125us

This patch enables pegasus driver to work fine with ETX-US2.

Signed-off-by: Tadashi Abe <tabe@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/pegasus.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/pegasus.h
+++ b/drivers/net/usb/pegasus.h
@@ -254,7 +254,7 @@ PEGASUS_DEV( "IO DATA USB ET/TX", VENDOR
 		DEFAULT_GPIO_RESET )
 PEGASUS_DEV( "IO DATA USB ET/TX-S", VENDOR_IODATA, 0x0913,
 		DEFAULT_GPIO_RESET | PEGASUS_II )
-PEGASUS_DEV( "IO DATA USB ETX-US2", VENDOR_IODATA, 0x092a,
+PEGASUS_DEV( "IO DATA USB ETX-US2", VENDOR_IODATA, 0x093a,
 		DEFAULT_GPIO_RESET | PEGASUS_II )
 PEGASUS_DEV( "Kingston KNU101TX Ethernet", VENDOR_KINGSTON, 0x000a,
 		DEFAULT_GPIO_RESET)


