Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1CXPUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:20:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1CXPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:20:44 -0400
Message-ID: <4D8B6140.4020300@pengutronix.de>
Date: Thu, 24 Mar 2011 16:20:32 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Rientjes <rientjes@google.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: multiple definition of `show_mem'
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7B7B2C4C841D68159CD4E817"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7B7B2C4C841D68159CD4E817
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

current mainline (v2.6.38-7210-gb81a618) on ARM/mxs has the following bui=
ld failure:

> lib/lib.a(show_mem.o): In function `show_mem':
> .../linux-2.6/lib/show_mem.c:67: multiple definition of `show_mem'
> arch/arm/mm/built-in.o:.../linux-2.6/arch/arm/mm/init.c:82: first defin=
ed here
> make: *** [vmlinux.o] Error 1

After reverting these patches the kernel compiles...

cbf978bfb12d7deca97d7333f65eda0381a072de oom: suppress nodes that are not=
 allowed from meminfo on page alloc failure
29423e77c06cee7d4e335ef4a7cbd949da978c91 oom: suppress show_mem() for man=
y nodes in irq context on page alloc failure
ddd588b5dd55f14320379961e47683db4e4c1d90 oom: suppress nodes that are not=
 allowed from meminfo on oom kill

No time to boot the kernel, though.

cheers, MArc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7B7B2C4C841D68159CD4E817
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2LYUUACgkQjTAFq1RaXHPbogCfafZe3qsVIVwb+NJ87PEJIMGN
sPsAoIC0LGyk3OIdAZIY+nauEVIZGnqv
=dKV1
-----END PGP SIGNATURE-----

--------------enig7B7B2C4C841D68159CD4E817--
