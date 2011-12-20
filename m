Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1LTFiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:38:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1LTFiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:38:06 -0500
Date: Tue, 20 Dec 2011 16:37:50 +1100
From: NeilBrown <neilb@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB
 is not available.
Message-ID: <20111220163750.00e135c6@notabene.brown>
In-Reply-To: <4EEF9FCA.4040401@xenotime.net>
References: <20111219001806.23170.14518.stgit@notabene.brown>
	<20111219002022.23170.36881.stgit@notabene.brown>
	<4EEF9FCA.4040401@xenotime.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8u7HVikDWRWb+SY=Wh459CP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8u7HVikDWRWb+SY=Wh459CP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Dec 2011 12:34:18 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:

> On 12/18/2011 04:20 PM, NeilBrown wrote:
> > This driver can configure the outputs as GPIO line instead of LEDs.  But
> > that only works if GPIOLIB is available.  So make that code conditional
> > on the library's availability.
> >=20
> > Also remove the 'teardown' callback as it is never called and should
> > never be needed.
> >=20
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>,
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>,
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> Hi Neil,
>=20
> with linux-next 20111219 and this patch applied, I now get:
>=20
> drivers/leds/leds-tca6507.c: In function 'tca6507_remove':
> drivers/leds/leds-tca6507.c:677:9: error: 'struct tca6507_chip' has no me=
mber named 'gpio'
> drivers/leds/leds-tca6507.c:678:3: error: implicit declaration of functio=
n 'gpiochip_remove'
> drivers/leds/leds-tca6507.c:678:33: error: 'struct tca6507_chip' has no m=
ember named 'gpio'
>=20
> when GPIOLIB is not enabled.

Drat - I forgot the 'remove' code.

I cannot easily compile for an ARCH that doesn't include GPIOLIB, but it
seems that if I put=20
  #undef CONFIG_GPIOLIB
at the top of leds-tca6507.c it comes close enough for testing.
So the next version should get that right.  I'll repost.

Thanks,
NeilBrown



--Sig_/8u7HVikDWRWb+SY=Wh459CP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvAfLjnsnt1WYoG5AQIduxAAsc+ARNeKg2xj/Hl8jhm9cFmHIiTzgxmT
GcpbVOC78dHausRvMrb+Gt0QG2SQsMBkwvlT1jRt/wu/+szb2EjN5ffYDNiMmMEi
ALfymcTfw1SEHuhnu6GLTTKlzqsRPqHpFLBVSku4YlPNUpIc15IWxOfIsLtjgNkK
jyKAa2MEn4Ej1Wfey8/H5egpCN9Er03P+TcrYcS9hC/9wXCWQe/6EnFVGCPd9nri
43RrQ/Stw0vOwSGG74wUGDM3wVuNP4y+rETc0S87SbW02LqlhYg5taaACH6RejtJ
yuITiuUr0eXyfYDlhsPfZ+NRx57flE64UumeBoGmmFXGdWNLzQ3anZodP6jqS7a/
fn17dhblS7ARDBPxMMQ8habd607hP8A1D7A2YKq3t7YGl06JetHHbWwkpaTmnvmz
dxw/9TTC12R2022jVG9WNwrsY68UwrEH8BBxT1fdDRc+OTkqpxEcmbIiEwNqR9a1
TqEINGSzvqe4QnORRfQO1SO/ndtGc53E4lmuX73L4V4/9VUJaZvehjkvbFAysZNp
f0L+0X2fH46hg57gSLACO4nZD9+3ZPR/Fo8CuqJyjvFO8EumkGojKpbtN5v9D6y3
3TP35VE4d0Uf/wqZyLx/Ej8kQIX1n5j+hE0ixfZ6OtlcvoGqZ3T4frpfIdTtV/3x
Rjlq7nQpQHU=
=A9pj
-----END PGP SIGNATURE-----

--Sig_/8u7HVikDWRWb+SY=Wh459CP--
