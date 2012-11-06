Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2KFLqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:46:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34482 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2KFLqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:46:43 -0500
Date: Tue, 6 Nov 2012 13:40:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 6/7] usb: dwc3-omap: Minor fixes to get dt working
Message-ID: <20121106114032.GH11931@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350307680-24938-1-git-send-email-kishon@ti.com>
 <1350307680-24938-7-git-send-email-kishon@ti.com>
 <50894198.40003@ti.com>
 <50895291.70106@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Content-Disposition: inline
In-Reply-To: <50895291.70106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 25, 2012 at 08:24:09PM +0530, kishon wrote:
> Hi Benoit,
>=20
> On Thursday 25 October 2012 07:11 PM, Benoit Cousson wrote:
> >Hi Kishon,
> >
> >On 10/15/2012 03:27 PM, Kishon Vijay Abraham I wrote:
> >>Includes few minor fixes in dwc3-omap like populating the compatible
> >>string in a correct way, extracting the utmi-mode property properly and
> >>changing the index of get_irq since irq of core is removed from hwmod
> >>entry.
> >>Also updated the documentation with dwc3-omap device tree binding
> >>information.
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>---
> >>  drivers/usb/dwc3/dwc3-omap.c |   14 ++++++--------
> >>  1 file changed, 6 insertions(+), 8 deletions(-)
> >>
> >>diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> >>index b84ddf3..10aad46 100644
> >>--- a/drivers/usb/dwc3/dwc3-omap.c
> >>+++ b/drivers/usb/dwc3/dwc3-omap.c
> >>@@ -318,11 +318,10 @@ static int __devinit dwc3_omap_probe(struct platf=
orm_device *pdev)
> >>  	struct resource		*res;
> >>  	struct device		*dev =3D &pdev->dev;
> >>
> >>-	int			size;
> >>  	int			ret =3D -ENOMEM;
> >>  	int			irq;
> >>
> >>-	const u32		*utmi_mode;
> >>+	u32			utmi_mode;
> >>  	u32			reg;
> >>
> >>  	void __iomem		*base;
> >>@@ -336,13 +335,13 @@ static int __devinit dwc3_omap_probe(struct platf=
orm_device *pdev)
> >>
> >>  	platform_set_drvdata(pdev, omap);
> >>
> >>-	irq =3D platform_get_irq(pdev, 1);
> >>+	irq =3D platform_get_irq(pdev, 0);
> >
> >Cannot you use the name of the resource to avoid that kind of trick?
>=20
> *name* is mostly used when we have multiple resource of the same type
> for a single device. Previously we were clubbing wrapper resources
> and core resources in a single hwmod device, so we had to use
> different indexing.
> But with dt we have separated those under two different devices and
> hence we can always use index as '0'. But if you think we should have
> *name*, let me know, I can resend this patch :-)

since there were no more replies here, i'm assuming Benoit's happy with
Kishon's explanation. Will apply this series as is.

--=20
balbi

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmPcwAAoJEIaOsuA1yqREWhIP/0vtawC3ptH7rBQyvUpUSxjd
QSIw+eyeeC8C5LqVHlcqn+12URCFJi/ifXaI5ZENoeP5ZH0I1trRv2ad+CVFo9ZU
NBilR9DhTNH+0hXhy29OkMCOlxiUgo7nWZEGu31K0JQWxTnqq4yP614NasiZkpSb
o3+LJQCiEe+wKCQaVwOftBy4/0ewfu1EgldsBgjXsElDoN+pXsFt/l+F9/FuFT9J
hRBCGWtMowFnkyT9/IMpGdfy38w60yzJZ21c3SwXPwFXw84sdkecz3Ie7ype6iYl
Xenmj472ckCZB5OR1Yb8gYEHo0kR6gznNzueqQYB19fuQBK/MSMv20P4Z4alr/1C
W6TQhQEKP6jHRb+djKz8FnQzyunZzSLGtvRNfUBuSOyVoNxq6tDxk58opUJ7r09r
3XBPyOJX/bCghTew9RLGUmbK9iXDbHEnNQiFi/XrY/8aqigtU+P4hr/NhfWm4TEb
4HbgLH3Zf8Og63oz8WrjCU5e3ae5gBpE+K+ux2dV+J0yWGXbIkTYftR2sV58m7Ab
F9oTMmDEg8Yx7kOQmFkNDcD+HGE0OIA4z6w54sdlegkmergyyNc1PZCiWmE1T/SK
DgTWy1+coOMRtt0+Bwydd8q3iCZ33FW05YsGiepwxJIji7x/C4jVOFINNTZ8qGjJ
pBKyNIFTiw8wRWCQuuyw
=/eJq
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
