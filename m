Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab1BPAr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:58 -0500
Received: from kroah.org ([198.145.64.141]:45213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab1BPArv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:01 2011
Message-Id: <20110216002101.190603695@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 021/176] USB serial: add missing .usb_driver field in serial drivers
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5620b5f7f19e9ee3fcf6ecf493fed7821b7b495b upstream.

This patch (as1443) fixes a bug found in many of the USB serial
drivers: They don't set the .usb_driver field in their
usb_serial_driver structure.  This field is needed for assigning
dynamic IDs for device matching.

In addition, starting with the 2.6.37 kernel, the .usb_driver field is
needed for proper autosuspend operation.  Without it, attempts to open
the device file will fail.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/io_tables.h   |    1 +
 drivers/usb/serial/iuu_phoenix.c |    1 +
 drivers/usb/serial/keyspan.h     |    4 ++++
 drivers/usb/serial/moto_modem.c  |    1 +
 drivers/usb/serial/oti6858.c     |    1 +
 drivers/usb/serial/qcaux.c       |    1 +
 drivers/usb/serial/siemens_mpi.c |    1 +
 drivers/usb/serial/spcp8x5.c     |    1 +
 drivers/usb/serial/usb-serial.c  |    8 ++++++--
 drivers/usb/serial/usb_debug.c   |    1 +
 10 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/io_tables.h
+++ b/drivers/usb/serial/io_tables.h
@@ -196,6 +196,7 @@ static struct usb_serial_driver epic_dev
 		.name		= "epic",
 	},
 	.description		= "EPiC device",
+	.usb_driver		= &io_driver,
 	.id_table		= Epic_port_id_table,
 	.num_ports		= 1,
 	.open			= edge_open,
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -1276,6 +1276,7 @@ static struct usb_serial_driver iuu_devi
 		   .name = "iuu_phoenix",
 		   },
 	.id_table = id_table,
+	.usb_driver = &iuu_driver,
 	.num_ports = 1,
 	.bulk_in_size = 512,
 	.bulk_out_size = 512,
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -546,6 +546,7 @@ static struct usb_serial_driver keyspan_
 		.name		= "keyspan_no_firm",
 	},
 	.description		= "Keyspan - (without firmware)",
+	.usb_driver		= &keyspan_driver,
 	.id_table		= keyspan_pre_ids,
 	.num_ports		= 1,
 	.attach			= keyspan_fake_startup,
@@ -557,6 +558,7 @@ static struct usb_serial_driver keyspan_
 		.name		= "keyspan_1",
 	},
 	.description		= "Keyspan 1 port adapter",
+	.usb_driver		= &keyspan_driver,
 	.id_table		= keyspan_1port_ids,
 	.num_ports		= 1,
 	.open			= keyspan_open,
@@ -579,6 +581,7 @@ static struct usb_serial_driver keyspan_
 		.name		= "keyspan_2",
 	},
 	.description		= "Keyspan 2 port adapter",
+	.usb_driver		= &keyspan_driver,
 	.id_table		= keyspan_2port_ids,
 	.num_ports		= 2,
 	.open			= keyspan_open,
@@ -601,6 +604,7 @@ static struct usb_serial_driver keyspan_
 		.name		= "keyspan_4",
 	},
 	.description		= "Keyspan 4 port adapter",
+	.usb_driver		= &keyspan_driver,
 	.id_table		= keyspan_4port_ids,
 	.num_ports		= 4,
 	.open			= keyspan_open,
--- a/drivers/usb/serial/moto_modem.c
+++ b/drivers/usb/serial/moto_modem.c
@@ -44,6 +44,7 @@ static struct usb_serial_driver moto_dev
 		.name =		"moto-modem",
 	},
 	.id_table =		id_table,
+	.usb_driver =		&moto_driver,
 	.num_ports =		1,
 };
 
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -157,6 +157,7 @@ static struct usb_serial_driver oti6858_
 		.name =		"oti6858",
 	},
 	.id_table =		id_table,
+	.usb_driver =		&oti6858_driver,
 	.num_ports =		1,
 	.open =			oti6858_open,
 	.close =		oti6858_close,
--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -86,6 +86,7 @@ static struct usb_serial_driver qcaux_de
 		.name =		"qcaux",
 	},
 	.id_table =		id_table,
+	.usb_driver =		&qcaux_driver,
 	.num_ports =		1,
 };
 
--- a/drivers/usb/serial/siemens_mpi.c
+++ b/drivers/usb/serial/siemens_mpi.c
@@ -42,6 +42,7 @@ static struct usb_serial_driver siemens_
 		.name =		"siemens_mpi",
 	},
 	.id_table =		id_table,
+	.usb_driver =		&siemens_usb_mpi_driver,
 	.num_ports =		1,
 };
 
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -650,6 +650,7 @@ static struct usb_serial_driver spcp8x5_
 		.name =		"SPCP8x5",
 	},
 	.id_table		= id_table,
+	.usb_driver		= &spcp8x5_driver,
 	.num_ports		= 1,
 	.open 			= spcp8x5_open,
 	.dtr_rts		= spcp8x5_dtr_rts,
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1332,11 +1332,15 @@ int usb_serial_register(struct usb_seria
 		return -ENODEV;
 
 	fixup_generic(driver);
-	if (driver->usb_driver)
-		driver->usb_driver->supports_autosuspend = 1;
 
 	if (!driver->description)
 		driver->description = driver->driver.name;
+	if (!driver->usb_driver) {
+		WARN(1, "Serial driver %s has no usb_driver\n",
+				driver->description);
+		return -EINVAL;
+	}
+	driver->usb_driver->supports_autosuspend = 1;
 
 	/* Add this device to our list of devices */
 	mutex_lock(&table_lock);
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -75,6 +75,7 @@ static struct usb_serial_driver debug_de
 		.name =		"debug",
 	},
 	.id_table =		id_table,
+	.usb_driver =		&debug_driver,
 	.num_ports =		1,
 	.bulk_out_size =	USB_DEBUG_MAX_PACKET_SIZE,
 	.break_ctl =		usb_debug_break_ctl,


