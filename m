Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1GPMhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50616 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab1GPMhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:03 -0400
Date: Sat, 16 Jul 2011 17:06:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the jdelvare-hwmon tree
Message-Id: <20110716170601.0ffa821a61bbcd8cf6c3a096@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_17_06_01_+1000_OpJ2WbPnptyKb+OM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_17_06_01_+1000_OpJ2WbPnptyKb+OM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the jdelvare-hwmon tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/hwmon/max1111.c: In function 'max1111_remove':
drivers/hwmon/max1111.c:213:2: error: incompatible type for argument 1 of '=
mutex_destroy'
include/linux/mutex-debug.h:21:13: note: expected 'struct mutex *' but argu=
ment is of type 'struct mutex'

Caused by commit d2fbca2996a8 ("hwmon: (max1111) Fix race condition
causing NULL pointer exception").  Missing '&'?

I have used the jdelvare-hwmon tree from next-20110707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_17_06_01_+1000_OpJ2WbPnptyKb+OM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIThZAAoJEDMEi1NhKgbsC30H/RqLd8PnZI5Duh/R/M2Xl21i
MFNgIp3Spi8GyOVtHIr5T0LM7hxb7uMNTKUnGLXNnFFcLLW80kx2XYxDYHOJmjUU
7+B5vZ77r5XinV+asPZu9JjQPI/QgX3V08Cs4PgqvL+jYujnilnbsBxQqmqV6hL5
QeQuWVYXzSdninubWp35QdP65Z9HeG1nOxue3XaTuaHSG/GNhLx8V6C07bdgLj0c
DfjwOSgVmERtP601GP/xnKLobBpYmcHjdBJEvW91M5UEZ3J6YcWNiqr9lGcRDW/x
vhBL85lvJ0gpnzlo9rbrCZMNPpGXc1dA56bvDyWf6PkQtNSvLgUVoA0jl0GvQ9o=
=Nu2w
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_17_06_01_+1000_OpJ2WbPnptyKb+OM--
