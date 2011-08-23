Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1HWSwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:52:46 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41054 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271Ab1HWSwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:52:41 -0400
Date: Tue, 23 Aug 2011 21:52:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        gregkh@suse.de, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH -next] usb: fix dwc3 build when USB_GADGET_DWC3 is not
 enabled
Message-ID: <20110823185235.GA11299@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110823160432.d24f8cad00951286bc18461e@canb.auug.org.au>
 <20110823110702.f5ea377c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20110823110702.f5ea377c.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 11:07:02AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix build error when CONFIG_USB_GADGET_DWC3 is not enabled:
>=20
> ERROR: "dwc3_send_gadget_ep_cmd" [drivers/usb/dwc3/dwc3.ko] undefined!
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/usb/dwc3/debugfs.c |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> --- linux-next-20110823.orig/drivers/usb/dwc3/debugfs.c
> +++ linux-next-20110823/drivers/usb/dwc3/debugfs.c
> @@ -437,7 +437,9 @@ static int dwc3_testmode_open(struct ino
>  	struct dwc3_gadget_ep_cmd_params par0;
>  	struct dwc3_gadget_ep_cmd_params par1;
>  	struct dwc3_trb         trb;
> +#ifdef CONFIG_USB_GADGET_DWC3
>  	int ret;
> +#endif
>  	u8 *buf0;
>  	u8 *buf1;
> =20
> @@ -478,8 +480,10 @@ static int dwc3_testmode_open(struct ino
> =20
>  	dwc3_send_testmode_cmd(dwc, 1);
> =20
> +#ifdef CONFIG_USB_GADGET_DWC3
>  	ret =3D dwc3_send_gadget_ep_cmd(dwc, 0, DWC3_DEPCMD_STARTTRANSFER, &par=
0);
>  	ret =3D dwc3_send_gadget_ep_cmd(dwc, 1, DWC3_DEPCMD_STARTTRANSFER, &par=
1);
> +#endif

instead of adding the ifdef here, would you add it gadget.h and provide
a nop when we're not building the gadget side ?

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU/bzAAoJEAv8Txj19kN1YIkH/jEXWjTDCYfGZ4I7JvJkFsPV
T3Gp9V8ceaSdDpB1F9NG4cW0rESwvaY6z133u+Elar23Y7pmvb9BaohVIfU3mAnn
yLzPiCJq3dLg7Qp+EaAnDVVTLhaPDlGDVYMEjT3VU5XoM67kl6O/iOGVJqoCNrBi
BaGqFtQLof80NiEIRkeAJX0i7Zcz0uB4dva9OacC/rmX2qC5ZB+10okQHNfHehQ1
A+z6g823v4S9CROcbroRNgnAOW09HpXXvqNJQEQy5gXfdWxHhn5NLJiGhd5QdaEt
ZUz+RKgwfSuAm1DX+n7SoxVCjrMns6wAf7nuSVSLGVJCGl27t1ZMR1EQ/O1AH4M=
=YXNh
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
