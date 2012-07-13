Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2GMEN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 00:13:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55669 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2GMEN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 00:13:57 -0400
Date: Fri, 13 Jul 2012 14:13:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120713141345.f71b7c01f720d616d74721dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jul_2012_14_13_45_+1000_cmlLDBJMkD9quo9v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Jul_2012_14_13_45_+1000_cmlLDBJMkD9quo9v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/char/mwave/mwavedd.c: In function 'register_serial_portandirq':
drivers/char/mwave/mwavedd.c:472:2: error: implicit declaration of function=
 'serial8250_register_port' [-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors
drivers/misc/ibmasm/uart.c: In function 'ibmasm_register_uart':
drivers/misc/ibmasm/uart.c:57:2: error: implicit declaration of function 's=
erial8250_register_port' [-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors

Caused by commit 2655a2c76f80 ("8250: use the 8250 register interface not
the legacy one").  Grep is your friend.

I have used the tty tree from next-20120712 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__13_Jul_2012_14_13_45_+1000_cmlLDBJMkD9quo9v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/6B5AAoJEECxmPOUX5FEzK8P/ArTXTHKLLC2jYLymA7DpAuK
C2bvrvJowRoi2o8js48OD8/9HxZY8BWIjqc4oE1fSDAnFJwWksdGauMLGBhxLL1S
K6+NwiuRnHyzxdJuMv9rGja2wWGNWrJm+E7yZ7RU22+eO3o9s0rlNsLJ7dNYIdqz
NgZ+zP4jL6dj+9YcSdA4H8kaG7btjJ/U/2QTbYYwUndWiQDfkZA88I4M2Shc3+KG
CByJzxYdTa7BBvOXLPBpPtz9oG8g7NYF53OqsELAAebzjwUD/lMXqf2yALxOpycW
QpNwAMKkGvPwD33CqqDMN4QqEeYE/FcNJuoPmTEC6cmHBbUA0LnH/Epwf8VrnGXs
R2+T2sfL4iS7W+2StgJPbLA3JdwuNufZH9vlKBixhdtCIvJBJ78SfVkDrRGA8ra2
bG5FjdXupq8kUvHYxS8D2+/ZoOEYrfPXxEreF80sDTXAdMPp9FxUt85fzM23Gc4X
xdlv61+z3Jz2X3jFmhk9UUpTBvmQbgRR2aM4oVEaPfmTRmRwM1nHO5BaaUWCdec3
XjIc46A35TIwY07TA+KVNJcBZfDNiu1SP15Fp5aieJ+W++pu7sOQpYSx4jeKNxaS
tFlQSfWrziJFU6du6c6qqMLEUsfhSJufyO3JNrmbPCnd1NV1VERaWsxvElWijwqA
HQjJR2vhiDmdIqyaA0VW
=qL9L
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jul_2012_14_13_45_+1000_cmlLDBJMkD9quo9v--
