Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1ANVKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:10:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57012 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1ANVKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:10:02 -0500
Date: Sat, 15 Jan 2011 08:09:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <Narendra_K@Dell.com>
Cc: <jbarnes@virtuousgeek.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Surya_Prabhakar@Dell.com>
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-Id: <20110115080949.62176a3c.sfr@canb.auug.org.au>
In-Reply-To: <20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
	<20110112160229.7b8d82c1@jbarnes-desktop>
	<alpine.LFD.2.02.1101122217370.19754@x980>
	<20110113075556.789ac3c3@jbarnes-vaio.home>
	<20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
	<20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__15_Jan_2011_08_09_49_+1100_LQy2HHBQvU.dkNjP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__15_Jan_2011_08_09_49_+1100_LQy2HHBQvU.dkNjP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Narendra,

On Fri, 14 Jan 2011 20:52:42 +0530 <Narendra_K@Dell.com> wrote:
>
> This patch addresses the build failure described in this thread by
> compiling fs/nls/nls_base.c always into vmlinux, thus making the base
> nls functions available always.

Even on platforms that don't support ACPI or DMI ...

> From: Narendra K <narendra_k@dell.com>
> Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmo=
dconfig
>=20
> This patch fixes the following build breakage introduced by the patch
> PCI:export ACPI _DSM provided firmware instance number and string to sysf=
s.
> (previously commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2).
>=20
> http://marc.info/?l=3Dlinux-pci&m=3D129313294112736&w=3D1
>=20
> drivers/built-in.o: In function `T.647':
> pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
>=20
> This happens because 'make allmodconfig' sets CONFIG_NLS=3Dm and makes
> 'utf16s_to_utf8s` unavailable to drivers/pci/pci-label.o which is built
> into vmlinux.
>=20
> This is fixed by making fs/nls/nls_base.c always compile as part of
> vmlinux thus making the base nls functions available always.
> +++ b/fs/nls/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for native language support
>  #
> =20
> -obj-$(CONFIG_NLS)		+=3D nls_base.o
> +obj-y				+=3D nls_base.o

You should really restrict this to CONFIG_ACPI || CONFIG_DMI ||
CONFIG_NLS ... maybe create a CONFIG_NLS_BASE that is selected by ACPI,
DMI and NLS?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__15_Jan_2011_08_09_49_+1100_LQy2HHBQvU.dkNjP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNMLudAAoJEDMEi1NhKgbsN0oH/1KVID8OJRpdVefLF+cPA/SB
s1KJ7HWCjUgdkYjIeiOMGau2u8d23/1EzgqFkz74S8biDIHECgFNdA/tvClmb5v4
CyHo08zFjO4FLxVCVoRgMCrG9X+H88d639inYSO2a2MlXvT3EL7fooyeswKKlpxp
MIGHlyYa+EpP4XxixO3+4drZ7FGjmTciA9DOeTnG8fO2f+wCDZqaLD6e9uWHx7ZJ
i8OI0Q0cFGQtZBLnLKC7sl0gCsfmhV9uk+i0c1CMmhbkIzUS+8moC7EQ+R4ZVPmP
HHjmhr3fTP/XmKpbXCsYqVgQIysZoQl5NVV+hbjg5iLU108K4e+BqUqp6ndkMr4=
=7KoQ
-----END PGP SIGNATURE-----

--Signature=_Sat__15_Jan_2011_08_09_49_+1100_LQy2HHBQvU.dkNjP--
