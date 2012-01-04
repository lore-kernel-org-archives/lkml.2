Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2ADRKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:10:23 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54118 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754169Ab2ADRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:10:19 -0500
Date: Wed, 4 Jan 2012 09:10:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Add Thinkpad SL510 to pci=nocrs blacklist
Message-ID: <20120104091015.0a8c1b2f@jbarnes-desktop>
In-Reply-To: <20120104163052.GA31667@redhat.com>
References: <20120104163052.GA31667@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.c2XXWwHEGvOChqGiOggePs"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.c2XXWwHEGvOChqGiOggePs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Jan 2012 11:30:52 -0500
Dave Jones <davej@redhat.com> wrote:

> Enabling CRS by default breaks suspend on the Thinkpad SL510.
> Details in https://bugzilla.redhat.com/show_bug.cgi?id=3D769657
>=20
> Reported-by: Stefan Kirrmann <stefan.kirrmann@gmail.com>
> Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> --- linux-3.1.noarch/arch/x86/pci/acpi.c~	2011-12-30 14:42:43.495717907 -=
0500
> +++ linux-3.1.noarch/arch/x86/pci/acpi.c	2011-12-30 14:45:09.296198024 -0=
500
> @@ -72,6 +72,16 @@ static const struct dmi_system_id pci_us
>  			DMI_MATCH(DMI_BOARD_NAME, "0M273C"),
>  		},
>  	},
> +	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D769657 */
> +	{
> +		.callback =3D set_nouse_crs,
> +		.ident =3D "Thinkpad SL510",
> +		.matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_BOARD_NAME, "2847DFG"),
> +			DMI_MATCH(DMI_BIOS_VERSION, "6JET85WW (1.43 )"),
> +		},
> +	},
>  	{}
>  };
> =20
>=20
>=20

Ah I see the Thinkpad patch now... applied this one too.   Thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/.c2XXWwHEGvOChqGiOggePs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBIf3AAoJEIEoDkX4Qk9hZwQQAJ4NWI6kqSpA2xLNEmnPrbc4
rRq66O9QVU0o+hFc2V2VNBde5N0duNL1o8NTpZTWM0G6xQc/PHfAr5OHndjjfedf
t35rurX6N0VlOv875XZimqWqR9iDglJ54nKKZumpnY3MlD99F9xEnku52sLJHa23
/0vgtaYTPfht1o+0HnUwH12ZF6hiQKbTkF9yUrfg3k4RIG2ZYC0VQjMPUZmlW7GY
8JUpHGYoGNxfzmRg68TpEkMIGSZ4KWHgbcaJbr7TMFsCrVK5nFflD7ZzJzwXfQre
4a9QUitZrW4M9qr/fPI8ttzk3PNmvhVS1WxUVidSbLVjx/l74H+KGHeIvr2JTQiJ
J95HYdFGYTEiZ6aWbOQp+PzVGY5NNrlb/2wXRagDqSSGCUhOnlee2FOsqm6xPZXO
J4XsbDDozw3TOjUVDgqaolFxnfwZKLg9r+C9SlSVRssgA/uKu1b4RhHeWumHub1D
xP5u0H2/Plbpg9277GBSBRBTQg1I2kYnPO3imoNa+FYuzl66X8fY4qK+GLqndWja
Pd6K7sN3NwwDvLXM0CUt1U8cuQRBHSZdKxO/M7y0cAAXsWFo+pwOSOzLBXBbvJRz
/8s+iW1yJpkPkyuaQhqVqKck3zC+8ixICPQ6jSJ8vb54rb76FMQUv6X6PaQDl80P
itSTreqLssmRMs8skUhE
=S9fu
-----END PGP SIGNATURE-----

--Sig_/.c2XXWwHEGvOChqGiOggePs--
