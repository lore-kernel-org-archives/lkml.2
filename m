Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2KMKFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:05:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2KMKFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:05:35 -0500
Date: Tue, 13 Nov 2012 11:05:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
Message-ID: <20121113100527.GB982@avionic-0098.mockup.avionic-design.de>
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
 <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de>
 <50A1F3A3.40905@nvidia.com>
 <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:HRGZAWP5E9If2XxqnPjBsS5O1xnAhbb6d4nEM8oTk35
 WP1QFhZ16YYnb38gOdsIkJZwjaywsmNw7h114kjnj5CxDflNvF
 DcRCe4+MGmxf6TtZoN0baG1yMCkPcSiNd1BIdSVriHZ9ar93t9
 oFrDKphmZ5kRnm0fw+GFAcE522cCoXGtx+OFCPaQCzxR+M33Yu
 4PutdCmxZUI/K0nm9+g3Jd6pdv/TfdIczdQCfHDa+I2SDUAvwo
 JT9t59OWwzUQkKY1D59mAW2N4YLWrBKUkxS59wbeZZyVNWLaFg
 l6nZO+jVr7v29lT4fkEqeUW/xkRo4p/JSqyfegg2wAKhXTCkpT
 ax6u7yZ1dbwqMKRKv27I76PQWhixwpujWAvqSTgMMTB1JXg7Zy
 2Ap8+mAKwUDz3S1uF7tp51wv2I6IuTCjpE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 08:48:22AM +0100, Thierry Reding wrote:
> On Tue, Nov 13, 2012 at 03:15:47PM +0800, Mark Zhang wrote:
> > On 11/13/2012 05:55 AM, Thierry Reding wrote:
[...]
> > > +int tegra_output_init(struct drm_device *drm, struct tegra_output *o=
utput)
> > > +{
> > > +       int connector, encoder, err;
> > > +       enum of_gpio_flags flags;
> > > +       struct device_node *ddc;
> > > +       size_t size;
> > > +
> > > +       if (!output->of_node)
> > > +               output->of_node =3D output->dev->of_node;
> > > +
> > > +       output->edid =3D of_get_property(output->of_node, "nvidia,edi=
d", &size);
> > > +
> > > +       ddc =3D of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus=
", 0);
> > > +       if (ddc) {
> > > +               output->ddc =3D of_find_i2c_adapter_by_node(ddc);
> >=20
> > The i2c adapter may not be ready at this time. For Tegra 2, the I2C bus
> > for HDMI is not dedicated and we need the i2cmux driver loaded before
> > this i2c can be used. It proved that sometimes i2cmux driver loads after
> > drm driver.
> >=20
> > So we need to add some logics to support driver probe deferral here.
> > Anyway, I'm just want you know about this and we can improve this later.
>=20
> Good point. Unfortunately tegra_output_init() isn't always used from
> within .probe(), so it isn't quite easy to handle deferred probe here.
> I'll have to take a look at how to solve this properly.

After a closer look at this I think what should be done here is split up
tegra_output_init() into a tegra_output_parse() that does the DT parsing
and tegra_output_init() that actually initializes the output.

I'll try to implement something like that for the next version.

Thierry

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQohtnAAoJEN0jrNd/PrOhHVIP/2FY1h7O30G9SvHRHDvFXKKm
ZPfCeoSPxyHu+cE4qVNn084NHttrYVuAcn1GUa4WeULVXP6RxGowKX2tAk1Ty/TQ
PHZ9A4i2cQeG8NwP0c14AC1cEfJ0Td5ry0RFdjBWdjXgRS+qXWo1n+Xk+Rpljve9
2Xi650YzOzdie8QIFaR7TkaiHAlkckhdts74oZBdsHAv4D+u1nvdb9UVd8Bx2K8C
kL47mfzHjpFB3s7G17LbBZC8kssxzCpkOGhhGu8t7zHSLHqOcCtGKbxsTcCwiK7L
Usxjb/+B/I59GexjkZ7wsiMiiQyWgjFtxVYfU9mrnQFhGNDo/SLStU8E5xQ8iHGd
u6uYHxCz8OGwjPlwDsb7HIvmCozA/gpBjE69tzV4RDUNyQGReqL/bPIAXxLv1Ti3
4FHhxwaZYPFix42EnQCLMkcaHn20RHwdwvUVPXIrGdWmIbo8SFF0Z+YN3Np8M1St
8OFRr+sSv4AHry/TLXD6AZBWXpJCgaxRiTSpbCPi/ZWoTSbXSlg2AjqgECvXg5XN
m8ZtdBJZ0edlo1fWcWSOXisnLXAnjhqzlSlEirE5s7JNvGDFqJAQSuNrDlEtuGz7
SIeYNmCHwmh2u0oiecf7muH4yKcxE0Gr5P1Av+XzIUlzhnppGWlueYOmrmzBCXXH
l4sgPAqi7NUwr0w+NXZe
=5RWK
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
