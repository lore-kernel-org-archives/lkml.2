Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2KMFvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:51:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35765 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2KMFvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:51:18 -0500
Date: Tue, 13 Nov 2012 16:51:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20121113165106.e592e23693663de49e9d78d0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_16_51_06_+1100_t/csKYQpBI/yInMe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_16_51_06_+1100_t/csKYQpBI/yInMe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/power/lp8788-charger.c:15:0:
include/linux/iio/consumer.h:76:21: error: unknown type name 'u8'
include/linux/iio/consumer.h:78:11: error: expected ';', ',' or ')' before =
'void'

Caused by commit 92d1079b281f ("staging:iio: add a callback buffer for in
kernel push interface").  Presumably just a missing include.

I have reverted that commit for today (it introduces a set of not yet
used interfaces).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_16_51_06_+1100_t/csKYQpBI/yInMe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQod/KAAoJEECxmPOUX5FEQCkP/30/Jq8dfiEEN5MIR4GbleB5
LkYHW9WODO5Q9ZXc/SBQa4p3ogYPVrMWZDq4A5tA5JGhLruZn1k90QisYknL4jDK
lSqcEyW/utqKYjtn3FOx0VNbkNmENQok/EzzOT+ooLpDiBc+i9NvaomikGwV/WIa
SjfxZSWa50uoWeHwesNfdELiEFhNcHBCTixuA6G7uVLVEeHFefcdOLCf9uPl6xUA
7IjMD6ilSU8N8qlUUKw+EHVjWGS0b/NXrEFgAtblLihw1PgX1xb1rftKT+t7dkeV
rTtHkkD88hKHDLUAyO7QWJJ5UZjLFeCMlA+EY5vRlSxvoDSdq+THo/J+oQCM5H9/
tiBJK6xv8O/72HDF0wYAeNZg2TKIv1MQwVHsbvT+ALP41ZKdEaQhGoEONskfdO19
7KP6nLE1pse572IIMDnqTAfi0GLIGjp0+2cQgWQ195NIp/sqMpjzUh+mM6Dc0SxZ
scuy+M4b8EKf6guCJwcVBXvNGsdWY2p+8HadDIitgZtdOZ5cJGls3r/K1pgThoGI
qpxmYZh75HaGE7LRzN4FOGWQhqZZPJt6o46le+SMcwUD3b/en1DttBrMxDivU9D7
1QfOk/eNk6uQZXYukZa+35h33bnX0aJ1lJivbVyj7mUsObAhA0pdCXEVt0XXtP/g
q3ZgMTZt5/aAYJ7lrOiM
=lRnk
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_16_51_06_+1100_t/csKYQpBI/yInMe--
