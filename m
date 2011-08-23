Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1HWJ7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:59:46 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48329 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1HWJ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:59:45 -0400
Date: Tue, 23 Aug 2011 12:59:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110823095938.GJ1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110823150854.2f6da7f66247c3d31b07e072@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RUqJLqMNe5u4kDWT"
Content-Disposition: inline
In-Reply-To: <20110823150854.2f6da7f66247c3d31b07e072@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RUqJLqMNe5u4kDWT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 03:08:54PM +1000, Stephen Rothwell wrote:
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first=
 use in this function)
>=20
> Caused by the interaction of the module.h split up with commit
> 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver") from the usb
> tree.
>=20
> I have applied this patch for today (Greg, this should be applied to your
> tree):
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 23 Aug 2011 15:05:25 +1000
> Subject: [PATCH] usb: include module.h in the DesignWare USB3 DRD driver
>=20
> Fixes this build error:
>=20
> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first=
 use in this function)
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/usb/dwc3/dwc3-pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 2578595..e3b77d2 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -38,6 +38,7 @@
>   */
> =20
>  #include <linux/kernel.h>
> +#include <linux/module.h>

that was my fault, I didn't know about Paul's commit. Please Greg, apply
this to your tree:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--RUqJLqMNe5u4kDWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU3oKAAoJEAv8Txj19kN1AtgIAIw1xBnv8+7CUvuuA1iJISx5
ogvr/yQkoDBKSt52aTtTxUeg8Nu6BkUGTHxMOY0n0J8s52kNB0BHVzTq4qfBwbrH
fHk7643HYA54nI5BEE7y3CC9Vk966nsMwlpw4VG3oz1ENBegkF57gdY2tCjo1U/5
6/wITUnRUZB9vQoA3NI2s1htvFWfUWfPSitoE/wFi8L6LK4HZqByJ+BlYAMHxFyW
7dZBqrGoBz117K9G3LjT+Rtzb8B4uG0aCKxBDd/CbevC2bRObgTZpVFUTpLz/Rwq
yK9NThgrn4UlBKWm7zUZMXBA89uxJ0dozxiqS9nGqsfMZjdKnwP5FK1Q50o6ank=
=/XyC
-----END PGP SIGNATURE-----

--RUqJLqMNe5u4kDWT--
