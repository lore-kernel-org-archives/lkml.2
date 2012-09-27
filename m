Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2I0FSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:18:33 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50896 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab2I0FSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:18:30 -0400
Date: Thu, 27 Sep 2012 08:13:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Message-ID: <20120927051328.GD12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-5-git-send-email-kishon@ti.com>
 <20120919115647.GI3772@arwen.pp.htv.fi>
 <CAAe_U6Kr8t1=T7MGMjAe+1n6S-NncypnPkXYqA2_FtVK=uxULA@mail.gmail.com>
 <20120926182719.GA10326@arwen.pp.htv.fi>
 <CAAe_U6+t1rQh4VWsFRob3gQHMjbfXzhnfCswF-Ah7da_Xsfv8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <CAAe_U6+t1rQh4VWsFRob3gQHMjbfXzhnfCswF-Ah7da_Xsfv8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 10:43:06AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>=20
> On Wed, Sep 26, 2012 at 11:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Wed, Sep 26, 2012 at 11:10:48AM +0530, ABRAHAM, KISHON VIJAY wrote:
> >> Hi,
> >>
> >> On Wed, Sep 19, 2012 at 5:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wro=
te:
> >> >> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
> >> >> omap4, the clk_get of this clock will fail since it does not have t=
his
> >> >> clock.
> >> >>
> >> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> >> ---
> >> >>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
> >> >>  drivers/usb/phy/omap-usb2.c                       |   28 +++++++++=
+++++++++++-
> >> >>  2 files changed, 30 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Do=
cumentation/devicetree/bindings/usb/usb-phy.txt
> >> >> index 7c5fd89..d5626de 100644
> >> >> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> >> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> >> @@ -24,6 +24,9 @@ Required properties:
> >> >>  add the address of control module phy power register until a drive=
r for
> >> >>  control module is added
> >> >>
> >> >> +Optional properties:
> >> >> + - has960mhzclk: should be added if the phy needs 960mhz clock
> >> >> +
> >> >>  This is usually a subnode of ocp2scp to which it is connected.
> >> >>
> >> >>  usb3phy@4a084400 {
> >> >> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb=
2.c
> >> >> index d36c282..d6612ba 100644
> >> >> --- a/drivers/usb/phy/omap-usb2.c
> >> >> +++ b/drivers/usb/phy/omap-usb2.c
> >> >> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct pla=
tform_device *pdev)
> >> >>       struct omap_usb                 *phy;
> >> >>       struct usb_otg                  *otg;
> >> >>       struct resource                 *res;
> >> >> +     struct device_node              *np =3D pdev->dev.of_node;
> >> >>
> >> >>       phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> >> >>       if (!phy) {
> >> >> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct pl=
atform_device *pdev)
> >> >>       }
> >> >>       clk_prepare(phy->wkupclk);
> >> >>
> >> >> +     if (of_property_read_bool(np, "has960mhzclk")) {
> >> >> +             phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_re=
fclk960m");
> >> >> +             if (IS_ERR(phy->optclk)) {
> >> >> +                     dev_err(&pdev->dev, "unable to get refclk960m=
\n");
> >> >> +                     return PTR_ERR(phy->optclk);
> >> >> +             }
> >> >> +             clk_prepare(phy->optclk);
> >> >> +     }
> >> >
> >> > instead, can't you just always try to get the clock but ignore the e=
rror
> >> > if it fails ?
> >>
> >> This clock is needed for usb2 to work in dwc3 (omap5). So we have to
> >> report the error in case we dont get the clock no?
> >
> > sure, but you don't need to bail out. Print a warning message such as:
> >
> > dev_dbg(&pdev->dev, "couldn't get refclk960m, trying without\n");
>=20
> but then we'll get this debug message for omap4 which actually doesn't
> need 960m clk.

then make it dev_vdbg(). It's just a debugging message, it's not saying
it will fail, it's just stating that clock isn't present and we're
trying without because it's known that some versions don't need that
clock.

Another way to do it, would be to request or not the extra clock, based
on the Revision Register (if this IP has one).

--=20
balbi

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQY+B4AAoJEIaOsuA1yqREjPcP/RAzLl+AEbRjeZ/txE7Xe/hN
Tha9CEp9olYgxR5H3p8fy3BFIXmhpBGLGBDn/sXdLWZdDrspFLO9eYPXR7E2SK6M
Zg0VyUCjXkp6KQn9bCmn6jFaHy+luslAEaWgBTVACzA5kCXMr8O3UAO9EKSgs8md
uhVsqmaLfql05d0pq+7j6C+QS3BYEqt2k8RqfQjkixX5vJ9pASXjIB48czx2ZoUH
qaIpX+JdZOL4xLF7Yr5k0nLoFNxFWyOy/4MIDB4Aw0jaPY+J+wodN8nkevVxuMPT
aJI1mydQaWBjkNFaN738ge6HwbNuk5bJMmSf8EAohn7O7/RzKfZL3GE5ycHWnUZH
OB9iAHpZiPT0vgRNsdqE0OqFXyi184gkp6yhkhEmDYy8fpuyqaHY5oQ9yBXB+Fot
W4JRLXalX7zKifHQXhvjB+OdFEMHh5/1BHSOsb5jryv0IazRvTNLTAPm7RWXBvCA
8VvpIFBmPxoUxyhLO+nursHlyAje3BJ3JJmKVRfZSeGaLm1IsfO5WM3efZwTnJi7
9IqR11rVHkih75M/+OUwoZ3W7v+YNLtS383QQaMlr2uGrSeVGQWuaR10Qs2H2WNV
GjptN0GeoODdjCG19FA8WFypSyKIHJQ/jX5f150toiGojyQBCYQYPU20aYMT6ulS
lrGWULihu4UH+mkUHFcS
=UBLD
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
