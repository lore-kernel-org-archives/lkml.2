Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2AOSyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:54:18 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:46089 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2AOSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:54:17 -0500
Date: Sun, 15 Jan 2012 21:54:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging/xgifb: Remove unsupported mode LCD_320x480
Message-ID: <20120115185445.GB3356@mwanda>
References: <1326651733-9242-1-git-send-email-peterhuewe@gmx.de>
 <1326651733-9242-2-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <1326651733-9242-2-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F1320C5.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2012 at 07:22:10PM +0100, Peter Huewe wrote:
> This patch removes the probed mode LCD_320x480 which isn't supported
> anyway since this mode falls through to the default (=3Dinvalid) mode in =
the
> XGIfb_validate_mode function (see line 529 ff. for details).
>=20
> By removing this assignment, we can use the LCD_TYPEs from the sis
> driver without modifications.
>=20
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/xgifb/XGI_main_26.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/=
XGI_main_26.c
> index 2502c49..c27dbf8 100644
> --- a/drivers/staging/xgifb/XGI_main_26.c
> +++ b/drivers/staging/xgifb/XGI_main_26.c
> @@ -2118,10 +2118,13 @@ static int __devinit xgifb_probe(struct pci_dev *=
pdev,
>  			reg &=3D 0x0f;
>  			hw_info->ulCRT2LCDType =3D XGI310paneltype[reg];
> =20
> -		} else {
> +		}
> +		#if 0

Uh...  Why not just delete this code and the code in
XGIfb_validate_mode() as well?

regards,
dan carepenter


--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPEyD0AAoJEOnZkXI/YHqRWV4P/ijONDtGMjnvbSnowc78+Ku6
5UQvDHpb+DY9cj5MJzjn1bDd0bLvSfX0JkxPfC3UfjU0Ve0/QxTKTMMRVhimaN9k
IWe6v0UROEQJJ9P3/8eUBnsvFLEq8Q+wjvgER/MLFP41KVGgvf69rLHgL7ptvLv+
Wv24mSr8IW7vm3qmisSOy6hyZJYbRiM5D6+IK3nJ12ddmztrhWJGF9hjzR5F+m3G
o0CmynBvTjsKHWFnkuv0zD95cDw4N/Pj+TQrsYeq922uDknfpRdkrTA4T67WSdkR
QewH0/U9Iy5CghsS4Bc5mQh0DhnbWSp/FXpyVB2kLLCacANrFsRlqlzg2qBaxh7l
xz8hJsxEnwbkId1WlVMfQr62B2CVyQlZiDh0gMYNjnu75Fhiys0sRiaGPdsoHma4
djENcPX99KYYkgIqN85moFme1+o4nSwfAhH+J4eDCKQLN1Hf4EGuKRHccClxQtBT
gWpvYhgu/VqN3zI7SupJCGvIm5oba0eFMTWbPqU7PFIc4+V4yqKaGABume+RKUW6
1K4QEZi6UeCMKc8EQIU60/BoxSBKFFweD1C6weTqpvOJ520XRvAQBpma6hRmTCFz
bdDngOik9Y2Q4sTSk0ATXi6E4hgagitFV8vS7JMNsnMqNdxWH+5s74I1xkOaAmh8
IvU8JYhu9vdsKgo2sUPQ
=ArPZ
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
