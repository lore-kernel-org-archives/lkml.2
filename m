Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2FOLl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:41:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35467 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660Ab2FOLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:41:27 -0400
Date: Fri, 15 Jun 2012 12:41:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: add new regulator driver for lp872x
Message-ID: <20120615114125.GC4482@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
 <CAF+7xW=Cb3b64khdNsnyfkJiS4Yt+j8tGFQExAoddXrtu=+5=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <CAF+7xW=Cb3b64khdNsnyfkJiS4Yt+j8tGFQExAoddXrtu=+5=Q@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 15, 2012 at 07:11:48PM +0800, Axel Lin wrote:

> > + =A0 =A0 =A0 ret =3D gpio_request(gpio, "LP872X DVS");

> devm_gpio_request

Better yet...

> > + =A0 =A0 =A0 gpio_direction_output(gpio, dvs->init_state);

=2E..devm_gpio_request_one().

> > +module_i2c_driver(lp872x_driver);

> I think you need to use subsys_initcall() here.

> Regulators need to be available early in init in order to allow them
> to be available for consumers when requested.

Well, it depends on the regulator.  Those with DCDCs that might supply
cpufreq do because cpufreq can't use deferred probes.  Others should now
be able to use deferred probes which should removed the need for this.

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2x8zAAoJEBus8iNuMP3dELgP/3fyJ+jPisOmGU9G6E23JAk9
xkpkb8NBc3iaMZpHDcWoro0LdGdQgcb9RQl4zE6wt4zU2B6SYAb+RYfA472mrpgR
1nX+r7HrwJs01kmnEaQL8ntUzJGvhIDrrn0PAVo3Cp3p0U5x7UePqE2ZIE/woGmH
VwMLKjgD9rz0Cc2wvREnEWYEef7g/RVaMHI829skLM3rRJRo/6kUuvzx1eW5fuzZ
Hp/8BIyldG1V5X0qsgWxTH3X0dJ+N3zQJ2Ur1bF1F+vJVGY5xNAwjx62FhFoMXHw
UQ57PgWiUg3pLvCfQ76InAR4zr4HnMHFatP6i+FUWeNgoXzh1ufjFQDoL8nl8Y38
aOOZ+FlvFASajIk10gdpTG7I2HNDUFtvSAzuOTruLReBUhV+GkV8SWqPQ8gG5/aq
ViXnkFiYvdJkc1dU3f9GCy3OzyS/pGaBzU/DCNTmSMWM0wlqio4XRBQ6JHsq5bup
j7BVJ23Ams763hxqDW/80yTrdIbQREimL+aww2awNtPe0c+5cJOotN44mwQSrFVR
suA87qczSzPTVow4hIX8r2rsIN0jvvJhu+XDs7gicnvW4ddCJZjCQlYtosY9lipf
yAWGgphuDpPSbkHfmHASm4juR6g2PcXVNV3/voOetzROhTbKrhLl43/IfTWOc+k1
aRB9Kq2Uhl8wCrcC3I5m
=oTki
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
