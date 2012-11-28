Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2K1Jk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:40:58 -0500
Received: from mail.gw90.de ([188.40.100.199]:38011 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab2K1Jkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:40:55 -0500
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 04:40:54 EST
Message-ID: <1354094368.4467.4.camel@mattotaupa>
Subject: Re: [PATCH v2] sp5100_tco: Add SB8x0 chipset support
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 28 Nov 2012 10:19:28 +0100
In-Reply-To: <1352993009-3448-1-git-send-email-mc74hc00@gmail.com>
References: <1352993009-3448-1-git-send-email-mc74hc00@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CoO0JgjYCAjEaLw/kj/A"
X-Mailer: Evolution 3.4.4-1.1~pre2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CoO0JgjYCAjEaLw/kj/A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Takahisa,


as replied to ticket #43176 in Bugzilla thanks a lot for your work.


Am Freitag, den 16.11.2012, 00:23 +0900 schrieb Takahisa Tanaka:
> The current sp5100_tco driver only supports SP5100/SB7x0 chipset, doesn't
> support SB8x0 chipset, because current sp5100_tco driver doesn't know tha=
t the
> offset address for watchdog timer was changed from SB8x0 chipset.
>=20
> The offset address of SP5100 and SB7x0 chipsets are as follows, quote fro=
m the
> AMD SB700/710/750 Register Reference Guide(Page 164) and the AMD SP5100

In English you leave a space before parentheses: =E2=80=A6 Guide (page 164)=
 =E2=80=A6

> Register Reference Guide(Page 166).

Dito.

>   WatchDogTimerControl 69h
>   WatchDogTimerBase0   6Ch
>   WatchDogTimerBase1   6Dh
>   WatchDogTimerBase2   6Eh
>   WatchDogTimerBase3   6Fh
>=20
> In contrast, the offset address of SB8x0 chipset is as follows, quote fro=
m
> AMD SB800-Series Southbridges Register Reference Guide(Page 147).

Dito.

>   WatchDogTimerEn      48h
>   WatchDogTimerConfig  4Ch
>=20
> So, In the case of SB8x0 chipset, sp5100_tco reads meaningless MMIO
> address(for example, 0xbafe00) from wrong offset address, and the followi=
ng

Dito.

> message is logged.
>=20
>    SP5100 TCO timer: mmio address 0xbafe00 already in use
>=20
> With this patch, sp5100_tco driver supports SB8x0 chipset, and can avoid
> iomem resource conflict.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D43176
> Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
>=20
> ---
> v1 -> v2
>  -Fix typo in module description and source code.
>  -Fix a bug that can't correctly determine the watchdog fired.
>  -Improve syslog messages.
>  -Truncate the commit log, because previous commit log is too long.

There are no too long commit messages. ;-)

> ---
>  drivers/watchdog/sp5100_tco.c | 321 +++++++++++++++++++++++++++++++++++-=
------
>  drivers/watchdog/sp5100_tco.h |  46 ++++--
>  2 files changed, 306 insertions(+), 61 deletions(-)

[=E2=80=A6]

Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-CoO0JgjYCAjEaLw/kj/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlC11yAACgkQPX1aK2wOHVgXAACaAsw75EUvCnPkJE4cO3DocpC+
3kAAnjI6EAB3fTtQwBukMLgR7/HeUvuk
=K1r7
-----END PGP SIGNATURE-----

--=-CoO0JgjYCAjEaLw/kj/A--

