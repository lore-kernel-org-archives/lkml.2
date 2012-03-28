Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2C1Qd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:33:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48189 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758507Ab2C1Qd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:33:57 -0400
Date: Wed, 28 Mar 2012 17:33:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
Message-ID: <20120328163354.GA3232@opensource.wolfsonmicro.com>
References: <1332869030.2213.46.camel@joe2Laptop>
 <4F72BD4F.9020305@ladisch.de>
 <1332919803.16535.22.camel@joe2Laptop>
 <20120328094609.GA3232@opensource.wolfsonmicro.com>
 <1332951765.16535.38.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOTFI1MayFoZtDo5"
Content-Disposition: inline
In-Reply-To: <1332951765.16535.38.camel@joe2Laptop>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zOTFI1MayFoZtDo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 09:22:45AM -0700, Joe Perches wrote:
> On Wed, 2012-03-28 at 10:46 +0100, Mark Brown wrote:

Please at least leave the blank lines others put in their mails when
quoting even if you don't add any between paragraphs yourself, it really
makes things much more legible.

> > > > Instead of doing a Makefile change that has no _obvious_ connection with
> > > > printk, wouldn't it be better to just define pr_fmt with "regulator: "?

> > This seems like a much better idea if we're going to do anything; it
> > means that we don't end up embedding module names in things (which are
> > after all a bit of an implementation detail) and get to pick the name so
> > we can do something like get the prefix which is used for the symbols in
> > the code even if things are split over multiple modules.

> A negative is that requires #defines in multiple
> source files or rearranging #includes to centralize
> that #define.

You only need to do this in cases where the module name isn't a good
choice which hopefully should be relatively rare, and I'd expect a lot
of the time things will be in one source file anyway (as with the
regulator case).

> A negative of the Makefile approach is the name is
> obscurely chosen.  A positive is it's only chosen
> once.

I don't think this is an either/or thing - you can default to using the
module name and override it where needed which like I say should
hopefully be relatively rare (though the sound tree will probably need
to do this pretty much everywhere due to the naming convention it uses).

> > In the case above we don't support modular build in the first place.

> Unrelated but is there any particular reason why
> the regulator core code couldn't be build as a
> module?

It's not worth bothering, it's needed spectacularly early on in most
practical systems (including by board files that are always built in as
bits of them run prior to I/O mappings and whatnot being set up).  The
main practical result would be lots more hassle with dependencies in
Kconfig so the randconfig folks can do their stuff and no change in
actual configurations that people deploy.

--zOTFI1MayFoZtDo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcz0qAAoJEBus8iNuMP3dMYsP/3v/fq+BjtY57Bq5iw6WyEos
+8AwvdgRKvZVds10TuHAd6q2rd6WMg9oS3qk6QOirHxnGpHlNFibuhV/QZEHG9uf
ePxFzRrMJmTSgB2e30l3epsDT2ZdGQizjNPjH4jGT3SMk1oMP35CrbbNjyQn9+QD
F2IzGPPg8CNczdq0kDKrrG0D11bZNYfLanS1TPm+pjCExjr0MDlzQ6EcerU+o+7t
qWtsnddTj3HOGauimvV1mR+DjJZnG2uzi6yl7Q49TVMeLYXkEk+HMucAUk7DzH7a
rZilUh0/mNS5sNWR9+4252xmAwLXajqhE9wDJjPKSwQ+XEGi+WZkuGbynWAkDnxu
Ha8l75i/M+Wppi2WX10nL8iSInGdDa5GIPujDc4/ZH9+kUqC2dKnO4X0V882yQnR
riZB9uR9eiURqmyTmr/79M+2owU3rPowb+RDC6BNA4Vvk3NfOn80DlPuRc+CyVVL
p4m7RDMZLak314BB0GMEs1B85IAOXFFa5E1tpYyYfWUkzoUZzHPWZcJrXYZVm6Bp
Efraez36sWd2BaepcjWoU2aAvoz6aviErmhZixEd73dLGqX90Fbu03agamUElhRX
sUi1gRBORDVfsKKZJ+9tPfjNrwUFCQrlG34xNJwQib2tGr6PURQ45pfKa4HzphQF
UxNJP+FoppV9NZ61Wg/6
=6UrZ
-----END PGP SIGNATURE-----

--zOTFI1MayFoZtDo5--
