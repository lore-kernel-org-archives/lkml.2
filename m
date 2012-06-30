Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab2F3Tlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:41:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2F3Tlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:41:51 -0400
Date: Sat, 30 Jun 2012 21:41:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <20120630181006.GC23990@avionic-0098.adnet.avionic-design.de>
 <201206301920.21158.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <201206301920.21158.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:p1wpmeKEMyHQT2WL8U/ou7hEbmX8RH2w62nrlG0Jlsi
 VtYCYn1f/xGTZ7M/xuKYZKpAfOe6452FRMdX3pLXVyJip2BhW2
 LVLiG+Vm3pKMpV8jnuP8Avd2BCUQTsPYmkzQSEFYAqlB5wEb9E
 fzYVaaeCekiI3ohXF1clcZnM0uxbuVgMvaWTi5Cc15kNE2jb0+
 Ben3DdsFThhwXkHyqq7+rmUZTRVOUaz0+ABCdeTGXHQp+tZYQC
 OF5Pgo7YasTTyztOLevhS61rBNQyvUMSNxX2pGEEMluQbg4ogQ
 CrriPbo9cEmMJ7TO7VHhK9caTTtItKzmlYCnl8d44/x8AJeMjr
 BjuK8qFUebwkpCF4dnZ50f5RGrgJIxIMQgxb/VrP/5cr7x5QlM
 U2HvjI2lokfALPNXRL6/GdybYlfOmAkzcG2C15jFfM1ZJ6/10Z
 +oTcj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 30, 2012 at 07:20:21PM +0000, Arnd Bergmann wrote:
> On Saturday 30 June 2012, Thierry Reding wrote:
> > I hadn't thought about the allyesconfig case yet. Adding a "depends on
> > !HAVE_PWM" to the PWM symbol should work and is the easiest fix to this
> > kind of problem while other PWM legacy API implementations are ported to
> > the PWM subsystem.
> >=20
> > Sascha, Arnd (Cc'ed): what do you think?
> >=20
> > I don't know if I'll get enough time to test this over the weekend but I
> > should get to it when I'm back in the office on Monday.
> >=20
> You cannot depend on a symbol in the same place that provides it -- that
> would be a recursive dependency (or a paradox).

The PWM symbol doesn't provide HAVE_PWM.

> I think that all the drivers that are not converted to the common PWM
> layer yet should depend on not enabling the common code. Once they
> are all moved over, that dependency will go away.

Right. That's exactly what I meant. If we add depends on !HAVE_PWM to
the PWM symbol that should result in both options conflicting, and
therefore not being built at the same time.

Thierry

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP71ZzAAoJEN0jrNd/PrOh+lkP/3uPnRlF24CHFFcEnn9hPBwA
lulOAETG6/bIvH4LPFoo6ldjnnMIs4tcnMe9DVF0GEgwJkWPfbGtkCpUE7vsqALW
SUdN41uZP3+nBh5GFfj98W99CeHoveJbSazIP7gVbpokLeNlUJ7iV4s9/2cxgDes
913dhTc33sIHk7z+IMlfphrOOoDAyh9po6mxRUQsSy7Jwbxng+x9FO0Zti1+oNvj
0OhIwuYdAeYodNHa1ggHlMyvjUyYLd6rBCTQEAs1JQS6aNSTjFR20b0FLZSkJ6mf
BuVY6YEJ3oyhZwcLwYSu9J/FF2po7OxYFJs1Fywb7H3sVbDBYhQJvZH/+I3esDE3
Qaxa6D7cw8jw/tCu62BQ/ra7mw8Kx/z/sh9wn1dl6WnGRe+Uy1YepWNKkyoRBWHy
T2ZZflFC78CJoFFMWOrUKZW8dtawqh4LjIog2wDvmQolUS4ItXi3If7h89OTPi2h
imCFOjczsZoX20wY2wzhclIrh1yoGBusNZY0R8oRtlUDQFWz/UQN20RrtKcgAUBW
wPz/cNRQDmmzdyWzfdHj8MLW0Gvy/rBT6ATUR5Pzow9uLf5h1QiHCV4566F+SSx5
1UfP+CPRpmc42KPbuQV/tkAxrIUdVRLGGyLnrn4KKSc3l0+JLbuTv9sj+xnBECmA
z87e6IAxwdS5SXcrU+Xl
=SvyG
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
