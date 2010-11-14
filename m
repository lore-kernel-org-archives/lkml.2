Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0KNX0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 18:26:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab0KNX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 18:26:05 -0500
Date: Mon, 15 Nov 2010 10:25:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Martin Wilks <m.wilks@technisat.com>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20101115102554.67514e8d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Nov_2010_10_25_54_+1100_eXs53=qOVGa=xQdv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Nov_2010_10_25_54_+1100_eXs53=qOVGa=xQdv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/dvb/dvb-usb/technisat-usb2.c: In function 'technisat_usb2_get=
_ir':
drivers/media/dvb/dvb-usb/technisat-usb2.c:643: error: 'struct dvb_usb_devi=
ce' has no member named 'rc_input_dev'
drivers/media/dvb/dvb-usb/technisat-usb2.c:649: error: 'struct dvb_usb_devi=
ce' has no member named 'rc_input_dev'
drivers/media/dvb/dvb-usb/technisat-usb2.c:654: error: 'struct dvb_usb_devi=
ce' has no member named 'rc_input_dev'
drivers/media/dvb/dvb-usb/technisat-usb2.c: At top level:
drivers/media/dvb/dvb-usb/technisat-usb2.c:732: error: unknown field 'rc_pr=
ops' specified in initializer
drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: braces around scal=
ar initializer
drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: (near initializati=
on for 'technisat_usb2_devices.rc.core.rc_interval')
drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: field name not in re=
cord or union initializer
drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: (near initialization=
 for 'technisat_usb2_devices.rc.core.rc_interval')
drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: field name not in re=
cord or union initializer
drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: (near initialization=
 for 'technisat_usb2_devices.rc.core.rc_interval')
drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: excess elements in=
 scalar initializer
drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: (near initializati=
on for 'technisat_usb2_devices.rc.core.rc_interval')
make[5]: *** No rule to make target `drivers/media/rc/keymaps/rc-technisat-=
usb2.c', needed by `drivers/media/rc/keymaps/rc-technisat-usb2.o'.  Stop.

Caused by commit f29235d71ad3995ef9f74ad2f5931eca4ecabdcd ("[media]
technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver")
interacting with commit 1639cc0c5348957c076c0304005632d4a1b63252
("[media] ir-core: make struct rc_dev the primary interface").

Please make sure your build tests build new/modified files.

I have used the v4l-dvb tree from next-20101112 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Nov_2010_10_25_54_+1100_eXs53=qOVGa=xQdv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4HACAAoJEDMEi1NhKgbs0lkH/2Z+S82OsKqkAK6fsYPOqfGp
juXWBPCCSXl6CVpiPAJ/rT2PubAxztYuZZ0S/AcYPrVxGCXTr1q6oDZsT0U/F/B4
b0tnxmCjt1QEDusppHlGosKnYoFtvjcc4jOWLd9fAM96IC5cJh+9DkZbOguWyF/a
dRUePgf9hewqww7i8ZUQ65ixEOTeU2ShERVUfjbEgrBc3d9lw21RWIQBLs8P0I4l
a7IOqf5ik9poZMOCOjqlxjMjdHdUt+YTT3jkzqKuCdq+bTfWcJSOsNiyrs52ndcL
lcOzYnH64BZP+V8hyZJQiCB2cKQFbQ2aqw5gUjFsXjTv9r8wDPhO6Nk6ajbZAbI=
=7Kic
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Nov_2010_10_25_54_+1100_eXs53=qOVGa=xQdv--
