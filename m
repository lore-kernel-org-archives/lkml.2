Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2CEOHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:07:18 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34662 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2CENxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 05/68] TTY: remove re-assignments to tty_driver members
Date: Mon,  5 Mar 2012 14:51:52 +0100
Message-Id: <1330955575-26641-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All num, magic and owner are set by alloc_tty_driver. No need to
re-set them on each allocation site.

pti driver sets something different to what it passes to
alloc_tty_driver. It is not a bug, since we don't use the lines
parameter in any way. Anyway this is fixed, and now we do the right
thing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c        |    1 -
 arch/m68k/emu/nfcon.c               |    1 -
 arch/xtensa/platforms/iss/console.c |    1 -
 drivers/char/pcmcia/synclink_cs.c   |    1 -
 drivers/char/ttyprintk.c            |    2 --
 drivers/isdn/capi/capi.c            |    1 -
 drivers/isdn/gigaset/interface.c    |    7 +------
 drivers/misc/pti.c                  |    5 +----
 drivers/mmc/card/sdio_uart.c        |    1 -
 drivers/net/usb/hso.c               |    2 --
 drivers/s390/char/con3215.c         |    1 -
 drivers/s390/char/sclp_tty.c        |    1 -
 drivers/s390/char/sclp_vt220.c      |    1 -
 drivers/s390/char/tty3270.c         |    1 -
 drivers/tty/amiserial.c             |    1 -
 drivers/tty/bfin_jtag_comm.c        |    1 -
 drivers/tty/cyclades.c              |    1 -
 drivers/tty/ehv_bytechan.c          |    1 -
 drivers/tty/hvc/hvc_console.c       |    1 -
 drivers/tty/hvc/hvcs.c              |    2 --
 drivers/tty/hvc/hvsi.c              |    1 -
 drivers/tty/ipwireless/tty.c        |    1 -
 drivers/tty/isicom.c                |    1 -
 drivers/tty/moxa.c                  |    1 -
 drivers/tty/mxser.c                 |    3 ---
 drivers/tty/n_gsm.c                 |    1 -
 drivers/tty/nozomi.c                |    1 -
 drivers/tty/pty.c                   |    4 ----
 drivers/tty/rocket.c                |    1 -
 drivers/tty/serial/ifx6x60.c        |    3 ---
 drivers/tty/serial/msm_smd_tty.c    |    1 -
 drivers/tty/serial/serial_core.c    |    1 -
 drivers/tty/synclink.c              |    1 -
 drivers/tty/synclink_gt.c           |    1 -
 drivers/tty/synclinkmp.c            |    1 -
 drivers/tty/vt/vt.c                 |    2 +-
 drivers/usb/class/cdc-acm.c         |    1 -
 drivers/usb/gadget/u_serial.c       |    1 -
 drivers/usb/serial/usb-serial.c     |    1 -
 net/bluetooth/rfcomm/tty.c          |    1 -
 net/irda/ircomm/ircomm_tty.c        |    1 -
 41 files changed, 3 insertions(+), 59 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 60c9093..9c9c634 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -919,7 +919,6 @@ simrs_init (void)
 
 	/* Initialize the tty_driver structure */
 
-	hp_simserial_driver->owner = THIS_MODULE;
 	hp_simserial_driver->driver_name = "simserial";
 	hp_simserial_driver->name = "ttyS";
 	hp_simserial_driver->major = TTY_MAJOR;
diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
index ab20dc0..8db25e8 100644
--- a/arch/m68k/emu/nfcon.c
+++ b/arch/m68k/emu/nfcon.c
@@ -127,7 +127,6 @@ static int __init nfcon_init(void)
 	if (!nfcon_tty_driver)
 		return -ENOMEM;
 
-	nfcon_tty_driver->owner = THIS_MODULE;
 	nfcon_tty_driver->driver_name = "nfcon";
 	nfcon_tty_driver->name = "nfcon";
 	nfcon_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 2c723e8..247e9d4 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -216,7 +216,6 @@ int __init rs_init(void)
 
 	/* Initialize the tty_driver structure */
 
-	serial_driver->owner = THIS_MODULE;
 	serial_driver->driver_name = "iss_serial";
 	serial_driver->name = "ttyS";
 	serial_driver->major = TTY_MAJOR;
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 07f6a5a..c3bcb12 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2836,7 +2836,6 @@ static int __init synclink_cs_init(void)
 
     /* Initialize the tty_driver structure */
 
-    serial_driver->owner = THIS_MODULE;
     serial_driver->driver_name = "synclink_cs";
     serial_driver->name = "ttySLP";
     serial_driver->major = ttymajor;
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index eedd547..46b77ed 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -184,12 +184,10 @@ static int __init ttyprintk_init(void)
 	if (!ttyprintk_driver)
 		return ret;
 
-	ttyprintk_driver->owner = THIS_MODULE;
 	ttyprintk_driver->driver_name = "ttyprintk";
 	ttyprintk_driver->name = "ttyprintk";
 	ttyprintk_driver->major = TTYAUX_MAJOR;
 	ttyprintk_driver->minor_start = 3;
-	ttyprintk_driver->num = 1;
 	ttyprintk_driver->type = TTY_DRIVER_TYPE_CONSOLE;
 	ttyprintk_driver->init_termios = tty_std_termios;
 	ttyprintk_driver->init_termios.c_oflag = OPOST | OCRNL | ONOCR | ONLRET;
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 0d47ebc..41a5644 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1287,7 +1287,6 @@ static int __init capinc_tty_init(void)
 		kfree(capiminors);
 		return -ENOMEM;
 	}
-	drv->owner = THIS_MODULE;
 	drv->driver_name = "capi_nc";
 	drv->name = "capi";
 	drv->major = 0;
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index b826dac..7e54577 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -669,17 +669,15 @@ EXPORT_SYMBOL_GPL(gigaset_if_receive);
 void gigaset_if_initdriver(struct gigaset_driver *drv, const char *procname,
 			   const char *devname)
 {
-	unsigned minors = drv->minors;
 	int ret;
 	struct tty_driver *tty;
 
 	drv->have_tty = 0;
 
-	drv->tty = tty = alloc_tty_driver(minors);
+	drv->tty = tty = alloc_tty_driver(drv->minors);
 	if (tty == NULL)
 		goto enomem;
 
-	tty->magic =		TTY_DRIVER_MAGIC;
 	tty->type =		TTY_DRIVER_TYPE_SERIAL;
 	tty->subtype =		SERIAL_TYPE_NORMAL;
 	tty->flags =		TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
@@ -687,9 +685,6 @@ void gigaset_if_initdriver(struct gigaset_driver *drv, const char *procname,
 	tty->driver_name =	procname;
 	tty->name =		devname;
 	tty->minor_start =	drv->minor;
-	tty->num =		drv->minors;
-
-	tty->owner =		THIS_MODULE;
 
 	tty->init_termios          = tty_std_termios;
 	tty->init_termios.c_cflag  = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 9a35db3..383133b 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -907,20 +907,17 @@ static int __init pti_init(void)
 
 	/* First register module as tty device */
 
-	pti_tty_driver = alloc_tty_driver(1);
+	pti_tty_driver = alloc_tty_driver(PTITTY_MINOR_NUM);
 	if (pti_tty_driver == NULL) {
 		pr_err("%s(%d): Memory allocation failed for ptiTTY driver\n",
 			__func__, __LINE__);
 		return -ENOMEM;
 	}
 
-	pti_tty_driver->owner			= THIS_MODULE;
-	pti_tty_driver->magic			= TTY_DRIVER_MAGIC;
 	pti_tty_driver->driver_name		= DRIVERNAME;
 	pti_tty_driver->name			= TTYNAME;
 	pti_tty_driver->major			= 0;
 	pti_tty_driver->minor_start		= PTITTY_MINOR_START;
-	pti_tty_driver->num			= PTITTY_MINOR_NUM;
 	pti_tty_driver->type			= TTY_DRIVER_TYPE_SYSTEM;
 	pti_tty_driver->subtype			= SYSTEM_TYPE_SYSCONS;
 	pti_tty_driver->flags			= TTY_DRIVER_REAL_RAW |
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index bd4a67c..5a2cbfa 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -1175,7 +1175,6 @@ static int __init sdio_uart_init(void)
 	if (!tty_drv)
 		return -ENOMEM;
 
-	tty_drv->owner = THIS_MODULE;
 	tty_drv->driver_name = "sdio_uart";
 	tty_drv->name =   "ttySDIO";
 	tty_drv->major = 0;  /* dynamically allocated */
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index e1324b4..2d2a688 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3313,7 +3313,6 @@ static int __init hso_init(void)
 
 	/* fill in all needed values */
 	tty_drv->magic = TTY_DRIVER_MAGIC;
-	tty_drv->owner = THIS_MODULE;
 	tty_drv->driver_name = driver_name;
 	tty_drv->name = tty_filename;
 
@@ -3322,7 +3321,6 @@ static int __init hso_init(void)
 		tty_drv->major = tty_major;
 
 	tty_drv->minor_start = 0;
-	tty_drv->num = HSO_SERIAL_TTY_MINORS;
 	tty_drv->type = TTY_DRIVER_TYPE_SERIAL;
 	tty_drv->subtype = SERIAL_TYPE_NORMAL;
 	tty_drv->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index e71a50d..176e07c 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -1145,7 +1145,6 @@ static int __init tty3215_init(void)
 	 * proc_entry, set_termios, flush_buffer, set_ldisc, write_proc
 	 */
 
-	driver->owner = THIS_MODULE;
 	driver->driver_name = "tty3215";
 	driver->name = "ttyS";
 	driver->major = TTY_MAJOR;
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index a879c13..40a9d69 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -551,7 +551,6 @@ sclp_tty_init(void)
 		return rc;
 	}
 
-	driver->owner = THIS_MODULE;
 	driver->driver_name = "sclp_line";
 	driver->name = "sclp_line";
 	driver->major = TTY_MAJOR;
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 5d706e6..b635472 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -685,7 +685,6 @@ static int __init sclp_vt220_tty_init(void)
 	if (rc)
 		goto out_driver;
 
-	driver->owner = THIS_MODULE;
 	driver->driver_name = SCLP_VT220_DRIVER_NAME;
 	driver->name = SCLP_VT220_DEVICE_NAME;
 	driver->major = SCLP_VT220_MAJOR;
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 2db1482..b43445a 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1784,7 +1784,6 @@ static int __init tty3270_init(void)
 	 * Entries in tty3270_driver that are NOT initialized:
 	 * proc_entry, set_termios, flush_buffer, set_ldisc, write_proc
 	 */
-	driver->owner = THIS_MODULE;
 	driver->driver_name = "ttyTUB";
 	driver->name = "ttyTUB";
 	driver->major = IBM_TTY3270_MAJOR;
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b84c834..b42f00d 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1974,7 +1974,6 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 
 	/* Initialize the tty_driver structure */
 
-	serial_driver->owner = THIS_MODULE;
 	serial_driver->driver_name = "amiserial";
 	serial_driver->name = "ttyS";
 	serial_driver->major = TTY_MAJOR;
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 3a99776..946f799 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -257,7 +257,6 @@ static int __init bfin_jc_init(void)
 	if (!bfin_jc_driver)
 		goto err_driver;
 
-	bfin_jc_driver->owner        = THIS_MODULE;
 	bfin_jc_driver->driver_name  = DRV_NAME;
 	bfin_jc_driver->name         = DEV_NAME;
 	bfin_jc_driver->type         = TTY_DRIVER_TYPE_SERIAL;
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c9bf779..98a1b8b 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -4090,7 +4090,6 @@ static int __init cy_init(void)
 
 	/* Initialize the tty_driver structure */
 
-	cy_serial_driver->owner = THIS_MODULE;
 	cy_serial_driver->driver_name = "cyclades";
 	cy_serial_driver->name = "ttyC";
 	cy_serial_driver->major = CYCLADES_MAJOR;
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 1595dba..4813684 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -825,7 +825,6 @@ static int __init ehv_bc_init(void)
 		goto error;
 	}
 
-	ehv_bc_driver->owner = THIS_MODULE;
 	ehv_bc_driver->driver_name = "ehv-bc";
 	ehv_bc_driver->name = ehv_bc_console.name;
 	ehv_bc_driver->type = TTY_DRIVER_TYPE_CONSOLE;
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index b6b2d18..8880adf 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -917,7 +917,6 @@ static int hvc_init(void)
 		goto out;
 	}
 
-	drv->owner = THIS_MODULE;
 	drv->driver_name = "hvc";
 	drv->name = "hvc";
 	drv->major = HVC_MAJOR;
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index df7e7a0..da0aa47 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1499,8 +1499,6 @@ static int __devinit hvcs_initialize(void)
 		goto index_fail;
 	}
 
-	hvcs_tty_driver->owner = THIS_MODULE;
-
 	hvcs_tty_driver->driver_name = hvcs_driver_name;
 	hvcs_tty_driver->name = hvcs_device_node;
 
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 1b5f28b..60bc451 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1088,7 +1088,6 @@ static int __init hvsi_init(void)
 	if (!hvsi_driver)
 		return -ENOMEM;
 
-	hvsi_driver->owner = THIS_MODULE;
 	hvsi_driver->driver_name = "hvsi";
 	hvsi_driver->name = "hvsi";
 	hvsi_driver->major = HVSI_MAJOR;
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index ef92869..6990b3b 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -614,7 +614,6 @@ int ipwireless_tty_init(void)
 	if (!ipw_tty_driver)
 		return -ENOMEM;
 
-	ipw_tty_driver->owner = THIS_MODULE;
 	ipw_tty_driver->driver_name = IPWIRELESS_PCCARD_NAME;
 	ipw_tty_driver->name = "ttyIPWp";
 	ipw_tty_driver->major = 0;
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e5c295a..b3a28b5 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1678,7 +1678,6 @@ static int __init isicom_init(void)
 		goto error;
 	}
 
-	isicom_normal->owner			= THIS_MODULE;
 	isicom_normal->name 			= "ttyM";
 	isicom_normal->major			= ISICOM_NMAJOR;
 	isicom_normal->minor_start		= 0;
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index d15a071..4a26323 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1036,7 +1036,6 @@ static int __init moxa_init(void)
 	if (!moxaDriver)
 		return -ENOMEM;
 
-	moxaDriver->owner = THIS_MODULE;
 	moxaDriver->name = "ttyMX";
 	moxaDriver->major = ttymajor;
 	moxaDriver->minor_start = 0;
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 8998d52..260d031 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2658,12 +2658,9 @@ static int __init mxser_module_init(void)
 		MXSER_VERSION);
 
 	/* Initialize the tty_driver structure */
-	mxvar_sdriver->owner = THIS_MODULE;
-	mxvar_sdriver->magic = TTY_DRIVER_MAGIC;
 	mxvar_sdriver->name = "ttyMI";
 	mxvar_sdriver->major = ttymajor;
 	mxvar_sdriver->minor_start = 0;
-	mxvar_sdriver->num = MXSER_PORTS + 1;
 	mxvar_sdriver->type = TTY_DRIVER_TYPE_SERIAL;
 	mxvar_sdriver->subtype = SERIAL_TYPE_NORMAL;
 	mxvar_sdriver->init_termios = tty_std_termios;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index fc7bbba..c43b683 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3120,7 +3120,6 @@ static int __init gsm_init(void)
 		pr_err("gsm_init: tty allocation failed.\n");
 		return -EINVAL;
 	}
-	gsm_tty_driver->owner	= THIS_MODULE;
 	gsm_tty_driver->driver_name	= "gsmtty";
 	gsm_tty_driver->name		= "gsmtty";
 	gsm_tty_driver->major		= 0;	/* Dynamic */
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 580da78..e7592f9 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1916,7 +1916,6 @@ static __init int nozomi_init(void)
 	if (!ntty_driver)
 		return -ENOMEM;
 
-	ntty_driver->owner = THIS_MODULE;
 	ntty_driver->driver_name = NOZOMI_NAME_TTY;
 	ntty_driver->name = "noz";
 	ntty_driver->major = 0;
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d505837..f96ecae 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -393,7 +393,6 @@ static void __init legacy_pty_init(void)
 	if (!pty_slave_driver)
 		panic("Couldn't allocate pty slave driver");
 
-	pty_driver->owner = THIS_MODULE;
 	pty_driver->driver_name = "pty_master";
 	pty_driver->name = "pty";
 	pty_driver->major = PTY_MASTER_MAJOR;
@@ -411,7 +410,6 @@ static void __init legacy_pty_init(void)
 	pty_driver->other = pty_slave_driver;
 	tty_set_operations(pty_driver, &master_pty_ops_bsd);
 
-	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
 	pty_slave_driver->name = "ttyp";
 	pty_slave_driver->major = PTY_SLAVE_MAJOR;
@@ -671,7 +669,6 @@ static void __init unix98_pty_init(void)
 	if (!pts_driver)
 		panic("Couldn't allocate Unix98 pts driver");
 
-	ptm_driver->owner = THIS_MODULE;
 	ptm_driver->driver_name = "pty_master";
 	ptm_driver->name = "ptm";
 	ptm_driver->major = UNIX98_PTY_MASTER_MAJOR;
@@ -690,7 +687,6 @@ static void __init unix98_pty_init(void)
 	ptm_driver->other = pts_driver;
 	tty_set_operations(ptm_driver, &ptm_unix98_ops);
 
-	pts_driver->owner = THIS_MODULE;
 	pts_driver->driver_name = "pty_slave";
 	pts_driver->name = "pts";
 	pts_driver->major = UNIX98_PTY_SLAVE_MAJOR;
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index de88aa5..b088e1e 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -2277,7 +2277,6 @@ static int __init rp_init(void)
 	 * driver with the tty layer.
 	 */
 
-	rocket_driver->owner = THIS_MODULE;
 	rocket_driver->flags = TTY_DRIVER_DYNAMIC_DEV;
 	rocket_driver->name = "ttyR";
 	rocket_driver->driver_name = "Comtrol RocketPort";
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 7e925e2..144cd39 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1375,12 +1375,9 @@ static int __init ifx_spi_init(void)
 		return -ENOMEM;
 	}
 
-	tty_drv->magic = TTY_DRIVER_MAGIC;
-	tty_drv->owner = THIS_MODULE;
 	tty_drv->driver_name = DRVNAME;
 	tty_drv->name = TTYNAME;
 	tty_drv->minor_start = IFX_SPI_TTY_ID;
-	tty_drv->num = 1;
 	tty_drv->type = TTY_DRIVER_TYPE_SERIAL;
 	tty_drv->subtype = SERIAL_TYPE_NORMAL;
 	tty_drv->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index 4f41dcd..b25e6ee 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -203,7 +203,6 @@ static int __init smd_tty_init(void)
 	if (smd_tty_driver == 0)
 		return -ENOMEM;
 
-	smd_tty_driver->owner = THIS_MODULE;
 	smd_tty_driver->driver_name = "smd_tty_driver";
 	smd_tty_driver->name = "smd";
 	smd_tty_driver->major = 0;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c8ad546..ccfbc2a2 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2196,7 +2196,6 @@ int uart_register_driver(struct uart_driver *drv)
 
 	drv->tty_driver = normal;
 
-	normal->owner		= drv->owner;
 	normal->driver_name	= drv->driver_name;
 	normal->name		= drv->dev_name;
 	normal->major		= drv->major;
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index ff8017f..2b2988c 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -4333,7 +4333,6 @@ static int mgsl_init_tty(void)
 	if (!serial_driver)
 		return -ENOMEM;
 	
-	serial_driver->owner = THIS_MODULE;
 	serial_driver->driver_name = "synclink";
 	serial_driver->name = "ttySL";
 	serial_driver->major = ttymajor;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 01a1ff4..32f8eda 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3795,7 +3795,6 @@ static int __init slgt_init(void)
 
 	/* Initialize the tty_driver structure */
 
-	serial_driver->owner = THIS_MODULE;
 	serial_driver->driver_name = tty_driver_name;
 	serial_driver->name = tty_dev_prefix;
 	serial_driver->major = ttymajor;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a7efe53..ddabb61 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3977,7 +3977,6 @@ static int __init synclinkmp_init(void)
 
 	/* Initialize the tty_driver structure */
 
-	serial_driver->owner = THIS_MODULE;
 	serial_driver->driver_name = "synclinkmp";
 	serial_driver->name = "ttySLM";
 	serial_driver->major = ttymajor;
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..1caec8b 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2991,7 +2991,7 @@ int __init vty_init(const struct file_operations *console_fops)
 	console_driver = alloc_tty_driver(MAX_NR_CONSOLES);
 	if (!console_driver)
 		panic("Couldn't allocate console driver\n");
-	console_driver->owner = THIS_MODULE;
+
 	console_driver->name = "tty";
 	console_driver->name_base = 1;
 	console_driver->major = TTY_MAJOR;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b3fd449..b32ccb4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1698,7 +1698,6 @@ static int __init acm_init(void)
 	acm_tty_driver = alloc_tty_driver(ACM_TTY_MINORS);
 	if (!acm_tty_driver)
 		return -ENOMEM;
-	acm_tty_driver->owner = THIS_MODULE,
 	acm_tty_driver->driver_name = "acm",
 	acm_tty_driver->name = "ttyACM",
 	acm_tty_driver->major = ACM_TTY_MAJOR,
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 6597a68..490b01d 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -1087,7 +1087,6 @@ int __init gserial_setup(struct usb_gadget *g, unsigned count)
 	if (!gs_tty_driver)
 		return -ENOMEM;
 
-	gs_tty_driver->owner = THIS_MODULE;
 	gs_tty_driver->driver_name = "g_serial";
 	gs_tty_driver->name = PREFIX;
 	/* uses dynamically assigned dev_t values */
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index a9c5e67..69230f0 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1235,7 +1235,6 @@ static int __init usb_serial_init(void)
 		goto exit_bus;
 	}
 
-	usb_serial_tty_driver->owner = THIS_MODULE;
 	usb_serial_tty_driver->driver_name = "usbserial";
 	usb_serial_tty_driver->name = "ttyUSB";
 	usb_serial_tty_driver->major = SERIAL_TTY_MAJOR;
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index a2d4f51..7adb03c 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1157,7 +1157,6 @@ int __init rfcomm_init_ttys(void)
 	if (!rfcomm_tty_driver)
 		return -ENOMEM;
 
-	rfcomm_tty_driver->owner	= THIS_MODULE;
 	rfcomm_tty_driver->driver_name	= "rfcomm";
 	rfcomm_tty_driver->name		= "rfcomm";
 	rfcomm_tty_driver->major	= RFCOMM_TTY_MAJOR;
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 253695d..828f886 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -122,7 +122,6 @@ static int __init ircomm_tty_init(void)
 		return -ENOMEM;
 	}
 
-	driver->owner		= THIS_MODULE;
 	driver->driver_name     = "ircomm";
 	driver->name            = "ircomm";
 	driver->major           = IRCOMM_TTY_MAJOR;
-- 
1.7.9.2


