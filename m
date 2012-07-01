Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2GAG4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 02:56:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2GAG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 02:56:50 -0400
Date: Sun, 1 Jul 2012 08:56:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <201206301920.21158.arnd.bergmann@linaro.org>
 <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
 <201206302012.32476.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <201206302012.32476.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ln0/IENChsBZHB2LADkhRH6t0cX6WqxkxwzfCqOtKpN
 cwNctBsSgCLJaWpOL299eudkMBxE+RdOsITLlbF3HjoQlRgRW1
 cADAViZWlPd/SQb+TzaDCY5m6vZ1WvkzCCGdM5EIfpRlRRAvYP
 G98iZAo4wh5J/4GjfyLKGvKFQAnQG74Kw64QxFdNhee4k3Nwmc
 m8EWYtvF1UoXfp/Hb0AnFgwSR+tlt5QM+7VJ+rWaHN3/jQVMQP
 OjxfAZl3T/wl8IV6qEHDv6FDIEmcyTVnbQ4HeOjYQyxqedMTLO
 z8zuReSX2G+oDh5ABimIGlZyUCTVebTFt7pbK87s+9vwH+pVPr
 5c2EOjzoK6hifCJDVyDKHc/wEP7oLRz+rDAA0Qth2BoA9+FM6X
 qQauzC1cns0y8uWKz1K0QzZWO+k3PfpwrjVBGSsbZlTBuC/z/c
 5RFOG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 30, 2012 at 08:12:32PM +0000, Arnd Bergmann wrote:
> On Saturday 30 June 2012, Thierry Reding wrote:
> > > I think that all the drivers that are not converted to the common PWM
> > > layer yet should depend on not enabling the common code. Once they
> > > are all moved over, that dependency will go away.
> >=20
> > Right. That's exactly what I meant. If we add depends on !HAVE_PWM to
> > the PWM symbol that should result in both options conflicting, and
> > therefore not being built at the same time.
>=20
> But I would add it to all other ones then, not the generic one!

But if we make the new PWM symbol conflict with HAVE_PWM, then it'll do
the right thing for any of the legacy PWM implementations, without
having to track them down. Furthermore it'll also keep the legacy
version by default and not allow the generic one to be enabled in that
case. This is more likely to cause less side-effects than the other way
around.

> One question though: if the generic pwm implementation does not set
> HAVE_PWM, how can a driver check its presence?

The driver depends on PWM. HAVE_PWM is the symbol for the legacy
implementations, while PWM is the new PWM API symbol.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP7/SnAAoJEN0jrNd/PrOhUT0P/2izcyoeswldajPfSpUbGbvR
2yPKgbqmwxjwpUUk46GuPQZjAmLKA6bSXLrevNVroZSAI1d1SmZzH/55wIzDj7Ia
iFnlHKYQis4iYQVYe3JluoxIeZjWeIe8RH2plXrSoBmzM06VgrGQsDjyKhQhwfqb
tVV4pzKDKQ4GkwAcasPzg4kmLQDCsdYFiK4At3fG8EqzfIkDaJGPG3L5SmgKTyaR
U5ue4qyGzVJHHA0dwwhnZsQz4mIGdirEp1X8X0rxCv6gwaUuR1cbfoCDOGJXNnmE
bcoj2LvQgU7KHE84b5G/3oGYAoToz4Pb44RpnnOPGs1ttIWRof4ifa2sz6c8AT8s
1uFS9sN+B/+ejJ8YEln25bjEyZdY9N6PVTgtUTPutInt3y6zl/a8lYoGoijF62MH
bYgs/a8Zos1Jc5+eaUx5VNqLrYgL/v15PL/R2hTOlNJDHxMEpxHSgKtK8t1XYvgr
hL9/TUMRdPKvZzpzsaSCE6Kq1XS6H8jMrTr9Mjbslg0zoEC+U8/zP8eFnH+HI2ns
b5zSn8qRPwL92UUxy64WnWnl0PMCJAxOEsgMTlbPq7OC1ObFeCvEt1opDZfdZHqf
VFdpVc7L2zW7/CStKOzQbKLbfuWUqCOK8UEU8TUGjf6aPtW2VJ5zCM1MfkeSFz4x
XdQR8XYWWjJyFADkfkvA
=FNTr
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
