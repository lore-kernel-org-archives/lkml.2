Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0LFADV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:03:21 -0500
Received: from phlare.wyrms.net ([99.158.15.237]:41762 "EHLO phlare.wyrms.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab0LFADU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:03:20 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Dec 2010 19:03:20 EST
Subject: Issue with firewire from 2.6.35.9 to 2.6.36.1
From: Robin Cook <rcook@wyrms.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iEPC4GbKDv176kjoX9E+"
Date: Sun, 05 Dec 2010 17:37:06 -0600
Message-ID: <1291592226.7134.1.camel@pheuri.wyrms.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iEPC4GbKDv176kjoX9E+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I recently upgraded from 26.35.9 to 2.6.36.1 and now the /dev/fwX
devices are not being created.  I have udev 164 installed.

2.6.35.9 dmesg firewire lines...

firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
firewire_ohci 0000:07:00.0: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT c=
ontexts, quirks 0x1
firewire_core: created device fw0: GUID 0010dc0001adc862, S400
firewire_core: created device fw1: GUID 00808803072803a5, S100
firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5

2.6.36.1 dmesg firewire lines...

firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
firewire_ohci 0000:07:00.0: setting latency timer to 64
firewire_ohci 0000:07:00.0: irq 75 for MSI/MSI-X
firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT c=
ontexts, quirks 0x1

I have compared the difference between the two kernel configs and the
only differences that I see that may apply to the firewire are:

 CONFIG_DNOTIFY=3Dy
-CONFIG_INOTIFY=3Dy
 CONFIG_INOTIFY_USER=3Dy

 # CONFIG_IEEE1394 is not set=20
+CONFIG_FIREWIRE_NOSY=3Dm =20
 CONFIG_I2O=3Dm

On the ieee1394 wiki page it says that these kernel option are expected
to be on for the libraw1394:

CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_EPOLL=3Dy

These option are correct in the 2.6.35.9 kernel but the CONFIG_INOTIFY
option is missing completely in the 2.6.36.1 kernel.

Is this a change in how the firewire works in the kernel and that udev
needs to be modified or is there something else wrong?

--=-iEPC4GbKDv176kjoX9E+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJM/CIbAAoJEDx9azGHxhuRTs4P/iXXwOyDG3L1edQBXl5MwOMW
YYRsHqIBY3lZGxm1N/nopxeFWiWtJgDhshQYvVUsvjXWB9ePut7R4CSCgBdxs0Gs
tLIgAPSLQ1+WX52IzRcpPqqdTWxfJadhzyQtLfI8ZOiDkBSszwu8sQf/nU9RfMiA
5bluhKiTT9enP4KZiQTnTCsSQrOi+23SucYCmvpEzJt0GduAxTMTL4cLwo5PNv33
oXj9inNxFJ998A2f3XhMciFqGtB87tR1A9p3FQf+vwEoFbKG6wgwzDhSGjy8ygN7
Eizq/N0u0VeQ5W9Pmq3cvsvD2TuSSKh8IaPHYIBabb8Lrqz3uFT8IgPZfsk8L4E+
p5vABNypTxlrtSMoYJhBIbnVITGrWuz5QzW2UCqY7w+GdC+F952WcpsyJYRb1n5I
3ELAMZcZGi1+4rx5l75mwLkOgLgo4piCuIwmSYNNtm0wjp3NHoe8o+bLg7wRr8pL
7Wpw7Q4HNyVmlqwhcxSMxHHCUlXKNgiI7sbPaxdh19HtchxSWhiTWsFFfyNfsMRu
Hvz1q2N973XDXNOzYMH2TxGmywDe9g5fykK1fc6YDYXO2DBWeuyUzPx7ckAnka0O
8JLHe+0oQK3HDN+srvQ3yjxGmakY8K0eCbBSaIDaoO0+8dYVx6QG93GpIw1F9rgY
opl2dBh8llXLrC9/tBVz
=6ReX
-----END PGP SIGNATURE-----

--=-iEPC4GbKDv176kjoX9E+--

