Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0LFUCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:02:23 -0500
Received: from passoire.arboi.fr.eu.org ([81.57.108.63]:46583 "EHLO
	passoire.arboi.fr.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0LFUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:02:22 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 15:02:22 EST
Date: Mon, 6 Dec 2010 20:53:45 +0100
From: Michel Arboi <michel@arboi.fr.eu.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for Fintek F71869 watchdoh
Message-ID: <20101206205345.639f31bb@marmite>
In-Reply-To: <20101206191930.GA3188@salidar.me.mortis.eu>
References: <4CFCB76D.2060405@redhat.com>
	<20101206191930.GA3188@salidar.me.mortis.eu>
Organization: Compilo ergo sum
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Ttn1dpTChjZ1TbcgiWnpkAr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Ttn1dpTChjZ1TbcgiWnpkAr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 6 Dec 2010 20:19:30 +0100
Giel van Schijndel <me@mortis.eu> wrote:

> Please insert that constant in the list of other Chipset ID's
> alphabetically sorted (to keep that list consistent).

Like this?

> The rest of that patch looks fine.  So if you perform the above
> modification you'll get my Ack.

Please note that this was just a quick hack. My basic tests showed that
the board did not reboot by itself, and it rebooted when I stopped the
watchdog process.
I downloaded the chip datasheet from Fintek's site but could not make
much sense out of it. It is rather terse.


--MP_/Ttn1dpTChjZ1TbcgiWnpkAr
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=f71808e_wdt.patch

--- ./drivers/watchdog/f71808e_wdt.c	2010-10-20 22:30:22.000000000 +0200
+++ /tmp/f71808e_wdt.c	2010-12-06 20:48:00.257989527 +0100
@@ -49,6 +49,7 @@
 #define SIO_F71808_ID		0x0901  /* Chipset ID */
 #define SIO_F71858_ID		0x0507  /* Chipset ID */
 #define SIO_F71862_ID		0x0601	/* Chipset ID */
+#define SIO_F71869_ID		0x0814
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
 #define SIO_F71889_ID		0x0723	/* Chipset ID */
=20
@@ -98,12 +99,13 @@
 MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load w=
ith"
 	" given initial timeout. Zero (default) disables this feature.");
=20
-enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg };
+enum chips { f71808fg, f71858fg, f71862fg, f71869, f71882fg, f71889fg };
=20
 static const char *f71808e_names[] =3D {
 	"f71808fg",
 	"f71858fg",
 	"f71862fg",
+	"f71869",
 	"f71882fg",
 	"f71889fg",
 };
@@ -308,6 +310,10 @@
 		superio_set_bit(watchdog.sioaddr, 0x29, 1);
 		break;
=20
+	case f71869:
+		/* GPIO14 --> WDTRST# */
+		superio_clear_bit(watchdog.sioaddr, 0x29, 4);
+		break;
 	default:
 		/*
 		 * 'default' label to shut up the compiler and catch
@@ -708,6 +714,9 @@
 	case SIO_F71882_ID:
 		watchdog.type =3D f71882fg;
 		break;
+	case SIO_F71869_ID:
+		watchdog.type =3D f71869;
+		break;
 	case SIO_F71862_ID:
 	case SIO_F71889_ID:
 		/* These have a watchdog, though it isn't implemented (yet). */

--MP_/Ttn1dpTChjZ1TbcgiWnpkAr--
