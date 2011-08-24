Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1HXEeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:34:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58821 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1HXEeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:34:04 -0400
Date: Wed, 24 Aug 2011 14:33:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20110824143354.d32c86b5143631442aca3700@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_14_33_54_+1000_tw_Ac6GV0NDB9=8A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_14_33_54_+1000_tw_Ac6GV0NDB9=8A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `dw8250_handle_irq':
8250_dw.c:(.text+0xcad9c): undefined reference to `serial8250_handle_irq'

CONFIG_SERIAL_8250 is 'm' and CONFIG_SERIAL_8250_DW is 'y' ...

Caused by commit 6b1a98d1c485 ("tty: serial8250: add helpers for the
DesignWare 8250").

I have used the ttye tree form next-20110823 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Aug_2011_14_33_54_+1000_tw_Ac6GV0NDB9=8A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVH8yAAoJEDMEi1NhKgbsljsH/0DrdGrwLx0VzUbPOm9oqbMs
tj+Z1hNHYkPaYXEivDWpFYD15lklcI9yLJ6lHoCHRVQymAa82may0YLogrSHtUMK
W7aw1dh3AiGyhSB2kSCSydFKQCeKP+b6dLUsSYA8FthASWttKejXSnz8iCdziJmW
NUy7CdFAqgwjOrh/xoDCCcEP21pHJJhmw7/Sh2PHklMzmoApGY+z0UINNCMPcXrW
nw378wmW727xMuMw36dwzc3IKvOK4ouLjWcfhbdTvydIFNTs40id0vNBjRqjyi2D
AM7FVNX0Z/5Bc8PrZgNPjg7KeebLbOCnhxKOhH2YbJrdNP47hT8o7B80fKUPp0g=
=GmUc
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_14_33_54_+1000_tw_Ac6GV0NDB9=8A--
