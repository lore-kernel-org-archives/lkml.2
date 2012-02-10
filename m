Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab2BJU7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:59:09 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36659 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760056Ab2BJU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:59:07 -0500
Date: Fri, 10 Feb 2012 12:59:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] PCI: print out suggestion about using pci=realloc
Message-ID: <20120210125902.37c9c55c@jbarnes-desktop>
In-Reply-To: <1328424908-6385-9-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-9-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GT=/9DncFcMr9l2XR_wQC.E"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GT=/9DncFcMr9l2XR_wQC.E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:07 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> let user know they could try if pci=3Drealloc could help.
>=20
> Suggested-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 22454c5..9526038 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1346,6 +1346,9 @@ again:
>  		goto enable_and_dump;
> =20
>  	if (tried_times >=3D pci_try_num) {
> +		if (pci_realloc_enable =3D=3D enable_not_set)
> +			printk(KERN_INFO "Some pci devices resources are not assigned, please=
 try to boot with pci=3Drealloc\n");
> +
>  		free_list(&fail_head);
>  		goto enable_and_dump;
>  	}

"Some PCI device resources are unassigned, try booting with pci=3Drealloc"

That said, I wonder if this will cause more problems than it solves.
In some cases the BIOS may not allocate all resources, but this will be
harmless since the user won't actually use the device, or the driver
for the device won't even use the BARs in question anyway (as happens a
lot for IO regions).

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/GT=/9DncFcMr9l2XR_wQC.E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYUWAAoJEIEoDkX4Qk9hZpkP/RZVZw449vRTIXC95YwWmeaJ
7yis2q6LPWFiLKuVSycsO0p59SE/jq1bgfkGtydCGrCidmXzpQY2wNkZ5v7LHGD4
2AlmJEHsza1EHfNzt+W2BybFBVx0ehjvhmuvJtcCH0hJu9SGC9MlriuKHPWNdnRn
RLZM4+1t9sb/SXqRJ1b/K+m1gZ3OvMaK7NJMZghDaW4IiPbDJKqiymMabQm/0a40
f4bgmYvzYxRFWnmYGr6rNUNwI80nBMP/9F8R+ituIavkhV7X2A+hjXdAsZ8bdGmr
AcOtVfWD+bJtx8/mq/xuz3wJeuLGflIh63JRJUrFKMm8CIk5skcaUyMQG0z/KI6F
i4hHK3OjIqZdkNTMYi9L633QgqOYqMXRE/MKbY86368oIQVN8cjiGAt8CKQzjj66
XNGZfFy+z1QHWtydgq+whM7IusnabonQfbPS64lx4rD+wFSq+L09BonWHzikxd0M
OIaGhb0tCdrYZfblB9jXERkDs77oKD2AxOfyyvWLShOzOs2t3VtjTo3ppKich7WG
tDRmPyUzIIdldx52lwLodWEDNCx4nIAOLntZq1NlOn/lQza9IKeiwgoezOoxMAbk
zFz647GV9sWsLfKUaY00OyCLGV/ufZLl39AEffDe/ArfQrhqTLcwqjY4Crwb9f0y
yCDFf4gtEdcNLXvoiOll
=S7Gv
-----END PGP SIGNATURE-----

--Sig_/GT=/9DncFcMr9l2XR_wQC.E--
