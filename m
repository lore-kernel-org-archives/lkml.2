Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2ADRIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:08:47 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33899 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756447Ab2ADRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:08:45 -0500
Date: Wed, 4 Jan 2012 09:08:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Add Dell Studio 1557 to pci=nocrs blacklist
Message-ID: <20120104090841.5007db44@jbarnes-desktop>
In-Reply-To: <20120104163311.GB31667@redhat.com>
References: <20111230193704.GA2874@redhat.com>
	<20120101145354.GA1791@elte.hu>
	<20120103093020.0cbcd735@jbarnes-desktop>
	<CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
	<20120104163311.GB31667@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z+8aTmjTXHVH+KUOJ+jJzCF"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z+8aTmjTXHVH+KUOJ+jJzCF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Jan 2012 11:33:12 -0500
Dave Jones <davej@redhat.com> wrote:

> The Dell Studio 1557 also doesn't suspend correctly when CRS is enabled.
> Details at https://bugzilla.redhat.com/show_bug.cgi?id=3D769657
>=20
> Reported-by: Gregory S. Hoerner <ghoerner@transcendingthought.com>
> Signed-off-by: Dave Jones <davej@redhat.com>
> =20
> --- linux-3.1.noarch/arch/x86/pci/acpi.c~	2012-01-04 11:19:36.783664477 -=
0500
> +++ linux-3.1.noarch/arch/x86/pci/acpi.c	2012-01-04 11:23:42.403666272 -0=
500
> @@ -75,6 +75,16 @@ static const struct dmi_system_id pci_us
>  	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D769657 */
>  	{
>  		.callback =3D set_nouse_crs,
> +		.ident =3D "Dell Studio 1557",
> +		.matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557");
> +			DMI_MATCH(DMI_BIOS_VERSION, "A09"),
> +		},
> +	},
> +	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D769657 */
> +	{
> +		.callback =3D set_nouse_crs,
>  		.ident =3D "Thinkpad SL510",
>  		.matches =3D {
>  			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
>=20

Looks like this depends on a Thinkpad patch you haven't sent yet; did
you mean to?

I've fixed it up by hand and applied both the 1536 and 1557 patches to
my for-linus branch.  I'll see if Linus wants to take it before he
releases (doubtful, but it would be nice if these machines just worked
with the new kernel).

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/z+8aTmjTXHVH+KUOJ+jJzCF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBIeZAAoJEIEoDkX4Qk9hE7wP/2uIDZ7nKn1kmMwJHyWdPAuE
bYx2BTJ9t58f3LkPH/C9c0ZvTtrcmJyaNtgy8uYD5luH2Wd3duu7CS2waFC2BVZ1
IWzPL6BCRKmiKXhv51F1c1eKIFpwkfMdGFqSr3Uaxjh1NoAERNW7IDmsJTcdrJzN
GnDbU9APBhn6xkMSyYH34A02F3L4vYHikQYE1rL+qK/EjBhfdt9SjyDB4q2DwJhT
6yiuqzoCJh/6ADAwhPGrGAejTO9IKUUtMPg52303G+QxwRpWVn+ch/AOI6cnVFcM
pFnjT09IWWwZBOSg4APrKssEr41N5xIHFscn/+I6D6rB65iKjMzGeZ+5PkjRN6rx
NCIf1/Kmie4KFmM+MHyvN60nI46MULNiOjTFiLyJHa6jgv/c2HuhDzqoE/I4LYUj
laFK94BoyGjTmM3olafssvBzIC4HhI/WaLyUQc9pa73bLA6pRRaqNfOcfMfvwOCz
yrUh1It5RU1xTPgYaIwVfQ4WfWpSfnthfyosr4SkP4LCnUgmF30c9BFIo3WLZnoD
MxPHps8EWXNcOBoJTRgpc4OeWmLzjW1E4NtFGaRK+1Jj4emSo79oVSw0CzGqS78K
B4KQq5cEVsKkww98noT5T+PjYSnJFmc2jfUUL9HUUSVbhgGh1pjb6qZA5O+UsmAa
E0e0O5DRvKjaZUJdFcwe
=sC+7
-----END PGP SIGNATURE-----

--Sig_/z+8aTmjTXHVH+KUOJ+jJzCF--
