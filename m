Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614Ab1JFANh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:13:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58758 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935580Ab1JFANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:13:36 -0400
Date: Thu, 6 Oct 2011 11:13:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, stable@kernel.org
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Message-Id: <20111006111317.531e6fcc1829fc9927d4924d@canb.auug.org.au>
In-Reply-To: <201110040940.12876.arnd@arndb.de>
References: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au>
	<201110040940.12876.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_11_13_17_+1100_azSOk0zn8BQoUPpA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_11_13_17_+1100_azSOk0zn8BQoUPpA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 4 Oct 2011 09:40:12 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tuesday 04 October 2011, Stephen Rothwell wrote:
> > After merging the arm-soc tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > ERROR: "clk_enable" [drivers/misc/atmel_pwm.ko] undefined!
> > ERROR: "clk_disable" [drivers/misc/atmel_pwm.ko] undefined!
> > ERROR: "clk_put" [drivers/misc/atmel_pwm.ko] undefined!
> > ERROR: "clk_get_rate" [drivers/misc/atmel_pwm.ko] undefined!
> > ERROR: "clk_get" [drivers/misc/atmel_pwm.ko] undefined!
> >=20
> > Caused by commit 9dccc010c816 ("ARM: at91: remove dependency for Atmel
> > PWM driver selector in Kconfig").
> >=20
> > I have used the arm-soc tree from next-20110930 for today.
>=20
> Ah, thanks for tracking this down. I actually noticed the same
> problem on an ARM build but did not realize it was from one of
> the patches I had jut put in there myself.
>=20
> I'm really glad I didn't send this to Linus cc:stable yet then.
> Nicolas, in my randconfig branch, I've fixed this by adding
>=20
> 	depends on HAVE_CLK
>=20
> which I think is the right solution. I'll replace your patch
> with one that does this if you don't mind.
>=20
> I'd also remove the stable tag for this patch, because it can
> have unintended side-effects on other architectures.

I am still getting the failure ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_11_13_17_+1100_azSOk0zn8BQoUPpA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjPKdAAoJEECxmPOUX5FEhmUQAJ5UcH0D9lBq76vNK+GfDXrL
0a02oZoSKUT2ChRRkO9N5V84zbLCB/dd/O6ref1sAo2pOUJoDxX0hgX9yPcjt2+7
vmQy2jY4DuMPWuVyS+I/nKPpIh2PsBBMXTqaoafw2ItM6uCeVuuj/D6xGtEHEE7a
NbgTTR97dsbNDD5Pd7O3HhpPtMoZKYrxaf4JuBSZJlg3TeROIFo0mTLfaihssdRI
m8nIya5Nw+zfVWgABf4gYeE+bFiksPC8Z05JFP+FOnzcqpzjBRbOmWdK06pZQQ/T
Jq4DZH5OBKL6T+6GrxtrbUpU2fMBwK9ldiruSrn3tPxl4bjz2lyTRyO9H9bj+UOj
xUfe7tSVXZwfHZS3fXZPVhjk5QdK6FOD5sOMN39OMXvFx+kBfwOgdixg8Z7TFMIP
QA2SFURKSxzgikpQNUK56LXluGKJr4rWlbq2lKFqQ5A/GyQkeB/qN7R7X+FBCERM
G5JYTYzY98+FqPt8/JoOq5DnXEFGSrYP0gp3wwGUYbTMLYq1fZIKvw5Rj7dM/t3a
YnZ0UmUlmfQ9C6z4UHHnzj4RxBlDQTie1OWe2V8gz5JpFd0j/s/cpZMYlTnlcDXD
E48cviKt+pKyBfi87xR+GwRGgFvUhk4vc8wsEiMS/6dP40KN+fFgUwp704qdRL2t
mYnH/SkEKuv0xakoz/3Q
=/csh
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_11_13_17_+1100_azSOk0zn8BQoUPpA--
