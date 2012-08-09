Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2HILTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:19:32 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:37369 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757972Ab2HILT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:19:29 -0400
Date: Thu, 9 Aug 2012 14:15:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120809111549.GT12174@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120707083949.2cf91eeb@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GAoked8QSizNecZ5"
Content-Disposition: inline
In-Reply-To: <20120707083949.2cf91eeb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GAoked8QSizNecZ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 07, 2012 at 08:39:49AM +1000, NeilBrown wrote:
>=20
> Hello `./scripts/get_maintainer.pl -f drivers/usb/musb/omap2430.c`
>=20
> omap2430_musb_set_vbus in omap2430.c contains:
>=20
> 			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
>=20
> 				cpu_relax();
>=20
> 				if (time_after(jiffies, timeout)) {
> 					dev_err(musb->controller,
> 					"configured as A device timeout");
> 					ret =3D -EINVAL;
> 					break;
> 				}
> 			}
>=20
> having set
> 	unsigned long timeout =3D jiffies + msecs_to_jiffies(1000);

hehe, that's nasty. Please send a patch converting to a try count and a
udelay_range(), or something.

--=20
balbi

--GAoked8QSizNecZ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQI5vlAAoJEIaOsuA1yqRE0OQQAJVpTeRaEXVUCW3l3963QpS7
vVYt8rjIudRYVHwqFE5oZf6RnRY2tPuzsKMVJABK/7r2lXm0Dia3lG9oJxO7heT+
9vFUahXJcxZenmv/XHmNJYUqcvmiVV/aD6VBrZRZCb+uqlkVzOLhnEvo8v11yU7b
Y3zj5emoUePYUQH+sPQrXZK1Sdgk35IsBPD/4DxTioFjKYt43h2gzaUcqIb4Sf0T
5eR+0hekPOQMMDP95NO5M210r+RearTX4EwPnRVxw4w6iBWeDszxJGim4Y7apmSz
rmBF1tCD8crLicW0/CBrI3JgNkqWAyxJ2Yi3SpMidv1JN3Gb/xVfQurcXiY35VI0
lW7soC/YpSZMh5lTcS3Fax5xqkMcEedZU9oHVZymWNQzrc/Dq5p5uKnUYsGTwBEL
9376//lrG7d3Rt7odsKCERPVB2DeYW7D6f5Xil6WBHZrJN21zJnNau1XXMPf1dL4
uhg/q23DRh8Qmadt/dDiUGt3q458AyrwgwZVgWIVNUA1ZN8U+kAt0nCkOilLJHHH
iSSfukpfQtpMFKkecIgmDyxkjTlkhbo/xFb8wMPyDiLCk83J1paeZWwqKhnyEVqQ
0cm+G5+nikSusDFraarTnRvk5DmE8BmoLBjjKKkt1RP4R7TxpkMytSVmRjT5iQ0B
pe1dt0QXCojk4o8u5CNV
=7GnU
-----END PGP SIGNATURE-----

--GAoked8QSizNecZ5--
