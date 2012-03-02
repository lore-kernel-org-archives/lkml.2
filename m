Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab2CBUEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:04:22 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49002 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756423Ab2CBUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:04:20 -0500
Date: Fri, 2 Mar 2012 12:04:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: add spinlock held check to
 'pcibios_fwaddrmap_lookup()'
Message-ID: <20120302120410.27cea21c@jbarnes-desktop>
In-Reply-To: <20120302194501.26152.22845.stgit@amt.stowe>
References: <20120302194501.26152.22845.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MCYpBC5OYh8763MegqY=qNS"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MCYpBC5OYh8763MegqY=qNS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Mar 2012 12:45:01 -0700
Myron Stowe <myron.stowe@redhat.com> wrote:

> 'pcibios_fwaddrmap_lookup()' is used to maintain FW-assigned BIOS BAR
> values for reinstatement when normal resource assignment attempts
> fail and must be called with the 'pcibios_fwaddrmap_lock' spinlock
> held.
>=20
> This patch adds a WARN_ON notification if the spinlock is not currently
> held by the caller.
>=20
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>=20
>  arch/x86/pci/i386.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 33e6a0b..831971e 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_look=
up(struct pci_dev *dev)
>  {
>  	struct pcibios_fwaddrmap *map;
> =20
> +	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
> +
>  	list_for_each_entry(map, &pcibios_fwaddrmappings, list)
>  		if (map->dev =3D=3D dev)
>  			return map;
>=20
>=20

Applied, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/MCYpBC5OYh8763MegqY=qNS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUSe6AAoJEIEoDkX4Qk9hzokP/R0b2ld/PC5EKBHQHGPiQc1D
SkVv+W9pLmXFI3zmO1FzBLfvqY8NDjqrBYDH+AxbWT+Cyrk6GH8Lr01OjfcqBJei
jHgZ/xc9HSXUpjzxYq1cKHP/a5chyl1Swx7p8Pye7jxID+GodRfh/eMJxWmjoGaK
wMKvhQme8s2CrwuSrFQZFuZrEwM/8GoWcZMZObsT0NsGK4Shy48KnSztd7LN4hUY
2GILGm05kso3qMJVD7dx2K0kxk8morI6t2XRBBLdC50Wkw+0s3vhoBZ4t0n3Wfes
wB4+fcbV3ENObaUnUyiJdm5Cyl5D0TDVlv8LjAFvxD40MPJLQFw8ITBnTpqoy580
/uU6TLfyuUl+eclP919fJWYb+lPChtmqYkb+YWA3NM9xhzCOn/kaBZ4XprKfVGdC
4PLh1t0KUuk+KwhNcm7RlOW9ohgKCWt9Adunt2EWa5N5DcuELPmHaEj63RWshupC
LkGkkXb/c/bNOQ1U/iikp3zuIKAf4W6x+uH/VjpZR3qHFu8/xeeTLlVhoc7T0/oS
gXt8PULqusRFqi0zimsTNN6v55jkmC4Yfn9CEcD1vR7jhf3MQplZXzrN00Uid+l7
2HH10OoY7Ncdiayzoh4Wx4eZqRH46tyd4OjC6V4IgbOIPhofVxhsomYeAcEfZ4uP
S7ApAig5SveTqNIT2MPP
=k1wN
-----END PGP SIGNATURE-----

--Sig_/MCYpBC5OYh8763MegqY=qNS--
