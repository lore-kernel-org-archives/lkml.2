Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0ECRHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:07:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64832 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0ECRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:07:45 -0400
Date: Mon, 3 May 2010 10:07:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: [PATCH -next] usbserial: fix mos7720 dependencies
Message-Id: <20100503100725.c4006b32.randy.dunlap@oracle.com>
In-Reply-To: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BDF02D8.0090:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mos7720 Kconfig dependencies.
When an enabled bool selects a tristate, the tristate becomes =y,
even if it should be limited to modular, so limit the bool kconfig
option to configs that will build cleanly.
Also change the if-block to a simple depends on.

drivers/built-in.o: In function `mos7720_release':
mos7720.c:(.text+0xad432): undefined reference to `parport_remove_port'
drivers/built-in.o: In function `mos7715_parport_init':
mos7720.c:(.text+0xae197): undefined reference to `parport_register_port'
mos7720.c:(.text+0xae210): undefined reference to `parport_announce_port'
drivers/built-in.o:(.data+0x201c8): undefined reference to `parport_ieee1284_read_nibble'
drivers/built-in.o:(.data+0x201d0): undefined reference to `parport_ieee1284_read_byte'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/serial/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-next-20100503.orig/drivers/usb/serial/Kconfig
+++ linux-next-20100503/drivers/usb/serial/Kconfig
@@ -425,16 +425,15 @@ config USB_SERIAL_MOS7720
 	  To compile this driver as a module, choose M here: the
 	  module will be called mos7720.
 
-if USB_SERIAL_MOS7720
 config USB_SERIAL_MOS7715_PARPORT
 	bool "Support for parallel port on the Moschip 7715"
+	depends on USB_SERIAL_MOS7720
+	depends on PARPORT=y || PARPORT=USB_SERIAL_MOS7720
 	select PARPORT_NOT_PC
-	depends on PARPORT
 	---help---
 	Say Y if you have a Moschip 7715 device and would like to use
 	the parallel port it provides.  The port will register with
 	the parport subsystem as a low-level driver.
-endif
 
 config USB_SERIAL_MOS7840
 	tristate "USB Moschip 7840/7820 USB Serial Driver"
