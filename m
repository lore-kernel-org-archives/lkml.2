Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2KZGJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:09:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2KZGJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:09:30 -0500
Date: Mon, 26 Nov 2012 17:09:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20121126170919.f7009838d3126e547205a705@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_17_09_19_+1100_1o+qFGV2aviHnW7i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_17_09_19_+1100_1o+qFGV2aviHnW7i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/devfreq/governor_simpleondemand.c: In function 'devfreq_simple_onde=
mand_func':
drivers/devfreq/governor_simpleondemand.c:36:11: error: dereferencing point=
er to incomplete type
drivers/devfreq/governor_simpleondemand.c:37:27: error: dereferencing point=
er to incomplete type
drivers/devfreq/governor_simpleondemand.c:38:11: error: dereferencing point=
er to incomplete type
drivers/devfreq/governor_simpleondemand.c:39:32: error: dereferencing point=
er to incomplete type

Caused by commit eff607fdb1f7 ("PM / devfreq: governors: add GPL module
license and allow module build").  The definition of struct
devfreq_simple_ondemand_data depends on
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND, but this is a modular build, so
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND_MODULE is defined instead.

I have used the pm tree fomr next-20121115 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Nov_2012_17_09_19_+1100_1o+qFGV2aviHnW7i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQswePAAoJEECxmPOUX5FEY84QAJBUq61pSOX/RkX+S4QK0+C3
UuribzSBIvnevLDHs4CxfHa0AmBiXJJRjBazod5aLqHwBAyR0YtZ0288mFI2eGJH
oAQCLPxYt0sp4slaLx30mKG2dN8VQPLle8TWlm7Fm0ylAcNhqDZkeFMVCXVVVKjO
dO1M3KqoJHV2T60IWfjyPyF5MXg0ZKiSB1DzhGR0MrCpOxEc/M2LZzteaVsB6O92
uzXK+llXXMj847B4G1lhywPBalCeK+pCxwZ63BIxar+mJR4c+ly3k0cF+cIQzi+5
333FOEH4OUsczVFzAjzfiHWopZypvZMW2Xl22CBccpJXzb5QYmr5rL4uJ0gceAti
oBjJkwHoXN3SKjy0tJCCcmaOzd9p+AcD3+bQzM9hZaUSGVNRGYPcmUaojA3mOx09
nl1GXNFjLQUWnkXhN12cV6aUF0wkWDtqHGti69EQUtt336sl3uKyy/qd06hET0Hm
cQs4XP0wKonXCq4SnPruW9VUjakwGSnlwF9ZMh0Lr8sJw/LK6bHgns2g8wwWGwZO
MsbBnvQvlLD0V8QIR0Kd/iig8oTyCTC6pxa6sN3z6prKmbsh3seWaUI1MI4DioyD
6/8zrWUm8dWS/ze7w3h+/dqmyQ+PT47eJUbpmXTibX/Zn7PQ2CellW8H2EofsCu/
3tU/0UczAmNmcyE4bjIp
=b/Na
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_17_09_19_+1100_1o+qFGV2aviHnW7i--
