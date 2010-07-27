Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0G0FSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:18:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34832 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0G0FSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:18:50 -0400
Date: Tue, 27 Jul 2010 15:18:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20100727151843.7d253148.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_15_18_43_+1000_VEQ2zmqaUpQSBDvo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_15_18_43_+1000_VEQ2zmqaUpQSBDvo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/serial/mfd.c:37:30: error: linux/serial_mfd.h: No such file or dire=
ctory
drivers/serial/mfd.c: In function 'port_show_regs':
drivers/serial/mfd.c:166: error: 'UART_FOR' undeclared (first use in this f=
unction)

... and on ... and on ...

Caused by commit c3190cf68dfc58c33de0fd59b919cbb864acbba4 ("hsu: driver
for Medfield High Speed UART device") and following.   Did it miss a file?

A little more care and testing, please.

I reverted that commit and the following three that depend on it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_15_18_43_+1000_VEQ2zmqaUpQSBDvo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTmwzAAoJEDMEi1NhKgbsrz4H/jkAUFU5T/VYP7V0zBskL6NO
2CNHs0Kw4BEAYRo+Ll0/wXtLV6lGfL/119czkg/eZy7n6EdF2fL8KD4zNQEr5oy6
a2FXpYrK7RTBpyRGgh/aTEyY4fUbqHn+T1mAX1rh72LwOiI/SaGxFzzfg9moJv9v
GNATi/Pb4OGKqn4dRU8NX+dhFa66Cg4BK6/R3g11Manuko/4pu6GWEMRVFxIrYy0
ALpu4vdkuP3qql9dnZ0WWe6NdfgMRviUgATZrP54rCboLQbIh4mEjnT7tun/fFT/
ScU3chGQhM+yQeHDZEc4E2fc3emctujWhwwEuRjCoFIZ5XKfG07/v0bEoWr0Pxo=
=YJk/
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_15_18_43_+1000_VEQ2zmqaUpQSBDvo--
