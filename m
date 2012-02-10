Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2BJU4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:56:49 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:54749 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759090Ab2BJU4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:56:47 -0500
Date: Fri, 10 Feb 2012 12:56:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] PCI: Make pci bridge reallocating enabled/disabled
Message-ID: <20120210125644.7521a0d8@jbarnes-desktop>
In-Reply-To: <1328424908-6385-8-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-8-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k3TtHVE.zN/B2otFIctClFh"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k3TtHVE.zN/B2otFIctClFh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:06 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Let the user could enable and disable with pci=3Drealloc=3Don or pci=3Dre=
alloc=3Doff
>=20
> Also
> 1. move variable and functions near the place they are used.
> 2. change macro to function
> 3. change related functions and variable to static and _init
> 4. update parameter description accordingly.
>=20
> -v2: still honor pci=3Drealloc, and treat it as pci=3Drealloc=3Don
>      also use enum instead of ...
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  Documentation/kernel-parameters.txt |    8 ++++++--
>  drivers/pci/pci.c                   |    4 +++-
>  drivers/pci/pci.h                   |    2 +-
>  drivers/pci/setup-bus.c             |   33 ++++++++++++++++++++++++++---=
----
>  4 files changed, 36 insertions(+), 11 deletions(-)
>=20
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-p=
arameters.txt
> index 033d4e6..e11e5dd 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2109,8 +2109,12 @@ bytes respectively. Such letter suffixes can also =
be entirely omitted.
>  				the default.
>  				off: Turn ECRC off
>  				on: Turn ECRC on.
> -		realloc		reallocate PCI resources if allocations done by BIOS
> -				are erroneous.
> +		realloc=3D	Enable/disable reallocating PCI bridge resources
> +				if allocations done by BIOS are too small to fit
> +				resources required by children devices.
> +				off: Turn realloc off
> +				on: Turn realloc on
> +		realloc		same as realloc=3Don

"too small to accommodate resources required by all child devices"

Looks good otherwise.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/k3TtHVE.zN/B2otFIctClFh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYSMAAoJEIEoDkX4Qk9hKRoQAIRSbIaOKoIECRJqRG2TIwEg
PtHBuO9/CrtyIuQwGzcu73/1ZCg3qjiyrEAl1SasV2dhG9/ns2HaWzYM1jG4L6sr
3N4f85nMpc28497kp+zcw+k00S7uFRASml/va0+lEmhVdVPuclqvtd/1F0oIVQOj
Qadi55BtKlPN4IU08LhKXhSw3cCNq+JYWa7q1uAC6s65qOmQgrnxia7U903LYzqE
NkCrq6TWw4TErSOZmm5Da2Af8OyVuyZ2bqFEM7FscC6osDviCkYhMANLOtqiDddY
0rN++1VxqOJP7WM03Oxnpd/Nf4mLuxAq5nxVhTh+phuZWlF8PQGDZBvcrNjc0vpb
qsJ/arzvPzDAd6CieQMQxx2FrvGywTIGSmP8tAZJtL+MRuvMKiirkLAOCkpJ2LTn
WpJ/Rl+9EGijlD8kFPJ2I6YBcfx3y9iF/b075IdAxMRqlyJZaFAB1eZIBwlyoBbk
Hqa8oJEiTkfc45M+ybaX+nVV+CMCeDK4LuX5oMLyOtMX+hfIso3wdAUj04xlDVvY
WzABEzf9axVi0DaNUZ1vzRDHhF96h+BMPPlAzsvZ3ulY09lGyPsA9U6QvxE1ZGGh
UNek48HltYMlPcTt7CBR3I3o7+OAfAtijhArlECLfbJcFlQqz53eYLs0iKu/EML0
08L5os9i8nckgZrNtQHK
=72Pc
-----END PGP SIGNATURE-----

--Sig_/k3TtHVE.zN/B2otFIctClFh--
