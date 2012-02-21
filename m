Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2BUBba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:31:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48344 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2BUBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:31:28 -0500
Date: Tue, 21 Feb 2012 12:31:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120221123117.2301242c47d6c7265263129a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Feb_2012_12_31_17_+1100_0xExhL/ushYzmwsb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Feb_2012_12_31_17_+1100_0xExhL/ushYzmwsb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `twl6040_driver_init':
twl6040-core.c:(.init.text+0xb147): undefined reference to `i2c_register_dr=
iver'
drivers/built-in.o: In function `twl6040_probe':
twl6040-core.c:(.devinit.text+0x7f22): undefined reference to `regmap_init_=
i2c'
drivers/built-in.o: In function `twl6040_driver_exit':
twl6040-core.c:(.exit.text+0x67a): undefined reference to `i2c_del_driver'


Caused by commit ded0df851077 ("mfd: Convert twl6040 to an i2c driver,
and separate it from twl core").

I have used the mfd tree from next-20120220 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_Feb_2012_12_31_17_+1100_0xExhL/ushYzmwsb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQvPlAAoJEECxmPOUX5FEh6IP/2ouTJejSruH9AIQgEfdqMm6
6KOU5nh6d4MXcpIrOAEpAbVRn0vBTVnBOXeGiKcWCGZNi1BRhSTDPWPYAcXYT1Kw
UDDXCOa2c1VGySdAWTD9kRQ+E9a1E9pP2QF+SfjJOnDKaCMDJWxNdK6EJY9VsVFB
GDkYgbah76X/MSvCnFzZAcVA+4CfoljOIBULT9PmhN+UenYnYrY8LpITenJJTO6Q
tt4sdRkcdGbvXrhBWBUAhjGQcqpQmeI5nNul28FdKcmzUq70Yy3J4lXRjE2aHx03
zkRc2axfOX9Ule6f0+Mv89OgBctYvB0nGUoNUnc33V4j8AHr8fOZUlS0jmWU91Ub
c7M919P3mMPZE2xxoPZyUoTGOuxe0weh7AwCU4bXIQhnBKvASNK+0qNd1sGbhHAd
zD101red8VjOvg8OEdZq5eVj/wyzSbWda92GxrM5Ukum4y4ZapOMe4XBWRGq/A/F
TlL/2m98lY1I00UfX1HwQK9mogQJ741PdDmReCTErQCV4h5kT7K4C4/U7sDtHQK9
Am3P/BdYw2F7munIPrYpGiF6uX/Wzmh4iBnVSQzER2a5Qb4gLVhLWoaKJaOn0kn2
zJiLYrOETuzoB4KMGAV/plSycuTtMh1KZdBGo3em7UMH/O3+zyM7Y7Qg8pSXZPWJ
YwJv8bhEIgFAeo74K/ff
=4J+9
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Feb_2012_12_31_17_+1100_0xExhL/ushYzmwsb--
