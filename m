Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab0KMAmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:42:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36601 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab0KMAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:42:37 -0500
Date: Sat, 13 Nov 2010 11:42:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] arch/powerpc: Use printf extension %pR for struct
 resource
Message-Id: <20101113114228.e87c6902.sfr@canb.auug.org.au>
In-Reply-To: <7654162f86bedd7d4cd5ccc883916157af6a2369.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
	<7654162f86bedd7d4cd5ccc883916157af6a2369.1289597644.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__13_Nov_2010_11_42_28_+1100_lKxOtA4JX7htl1kc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__13_Nov_2010_11_42_28_+1100_lKxOtA4JX7htl1kc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Fri, 12 Nov 2010 13:37:53 -0800 Joe Perches <joe@perches.com> wrote:
>
> Using %pR standardizes the struct resource output.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/kernel/pci_64.c     |    3 +--
>  arch/powerpc/sysdev/tsi108_dev.c |    8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index d43fc65..2ecb1de 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -193,8 +193,7 @@ int __devinit pcibios_map_io_space(struct pci_bus *bu=
s)
>  	hose->io_resource.start +=3D io_virt_offset;
>  	hose->io_resource.end +=3D io_virt_offset;
> =20
> -	pr_debug("  hose->io_resource=3D0x%016llx...0x%016llx\n",
> -		 hose->io_resource.start, hose->io_resource.end);
> +	pr_debug("  hose->io_resource=3D%pR\n", &hose->io_resource.start);
                                              ^^^^^^^^^^^^^^^^^^^^^^^^
Shouldn't this be just &hose->io_resource?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__13_Nov_2010_11_42_28_+1100_lKxOtA4JX7htl1kc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM3d70AAoJEDMEi1NhKgbszukIAJcqLoTVwsJzzuv55pl5aGta
bMzhbSdHTWiSj7JoziQxpb+pa+xJCTnpnTIOCBRyy0Au0pZ50m6dshS59vp/dO/h
Pc2GVRpXDaat2aj0H6m/RWCzgI/9R7eu/bMiItyVNhkfAu4nlQPItcvFDMaMS6bB
XITjWGTu+Otky4UhsqnUS/7bUfUVznwpJQIzr+1iil81/oQEOP8TuFky+yChSaIy
7ANRARhItxIAy3aRqjk3VZHBi7obIlNn4EOpTtXb8bJuMsS4IzEwsTPtSYNwlYZN
ZqebL8mPhIiQfLrGEtqiGU6tjDLWt2ORkpxO+21Pi/Gb2etgLm/5XGSwIL53lPo=
=O6gl
-----END PGP SIGNATURE-----

--Signature=_Sat__13_Nov_2010_11_42_28_+1100_lKxOtA4JX7htl1kc--
