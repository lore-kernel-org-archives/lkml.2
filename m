Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0I2B3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:29:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37025 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab0I2B3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:29:11 -0400
Date: Wed, 29 Sep 2010 11:29:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20100929112904.3fd117e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Sep_2010_11_29_04_+1000_qHqZR7X1cx8wn0ZF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Sep_2010_11_29_04_+1000_qHqZR7X1cx8wn0ZF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/video/bt8xx/bttv-input.c: In function 'init_bttv_i2c_ir':
drivers/media/video/bt8xx/bttv-input.c:306: error: too few arguments to fun=
ction 'i2c_new_probed_device'

Caused by commit 3c81f945a74224d6e3017596297ee9903929b1a7 ("V4L/DVB:
bttv: Move PV951 IR to the right driver") interacting with commit
9a94241afcc9a481691a9c29b7460217925b59b8 ("i2c: Add support for custom
probe function") that entered Linus' tree in v2.6.36-rc1.  I guess that
the v4l-dvb commit moved that code to a driver that is now being built.

I have used the v4l-dvb tree from next-20100928 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Sep_2010_11_29_04_+1000_qHqZR7X1cx8wn0ZF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMopZgAAoJEDMEi1NhKgbst10H/RM5c7pRguuuZz25+rOpRpLK
kMPovEaWsaF6wOaHfR2CAUyeHvkOrlpzhHXXdupZxjawYNmI3XJkmvtmVtMMq7Wq
rB3x730YIjhySoyke/MZfLphMRbaMir/kHSzpAF1F9FliDGEyEaCAW8mPqXOqg2p
PVlV/VY0NYQpbLmtPAEuWd4z2YahIUR/aI3L0GWWnhnvE7asDDMqazI3gqI3ktqj
nvqyCritDUCtCB8kOrDr81ZHm+BTxmrPdwUEkkBYsYnYlq6iLliAXE8kofR0g0mi
43OoNjCH12S4ZMFWjZAaA6b4XvvPuAf9KRzQMtU5MuQn08eCkagtAZQWGDi3LlY=
=6XlD
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Sep_2010_11_29_04_+1000_qHqZR7X1cx8wn0ZF--
