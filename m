Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1I3DFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:05:54 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58174 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab1I3DFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:05:53 -0400
Date: Fri, 30 Sep 2011 13:05:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20110930130550.2f6597491fa1b59f3be839e0@canb.auug.org.au>
In-Reply-To: <CAP=VYLoycp1aUYGxQkb+U70CFRvu=nz6pdd63Zapn7a-+gXWVw@mail.gmail.com>
References: <20110930111241.829ed0ada733516b71ab120d@canb.auug.org.au>
	<CAP=VYLoycp1aUYGxQkb+U70CFRvu=nz6pdd63Zapn7a-+gXWVw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_13_05_50_+1000_U1BJD/rDZ6KB7uU8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_13_05_50_+1000_U1BJD/rDZ6KB7uU8
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 29 Sep 2011 22:40:59 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> On Thu, Sep 29, 2011 at 9:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > After merging the final tree, today's linux-next build (avr32 allnoconf=
ig)
> > failed like this:
> >
> > arch/avr32/mach-at32ap/pio.c: In function 'pio_probe':
> > arch/avr32/mach-at32ap/pio.c:401: error: 'THIS_MODULE' undeclared (firs=
t use in this function)
> >
> > Probably revealed by the module.h split up. =C2=A0I guess it needs expo=
rt.h
> > included.
>=20
> Since export.h does not exist for most people, I'm OK adding it
> in instances like this as a post-merge patch.

I had another look at this and it turns out that export.h is already
included, but only conditionally.  I guess the include just needs moving
to the top of the file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_13_05_50_+1000_U1BJD/rDZ6KB7uU8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhTIOAAoJEDMEi1NhKgbsxnMIAKJ8JZBbKnSP1V17dglTn+Vp
otaoj9N42oEbVnXXl8ygV4oPbM48bjb3+S04oDiKt4Y/iabRYOqP+0xf8osuX9JJ
qKpQeu6yi7S07IiO9OMhbftv6paUZw/R6g3V2Te7NpXwJrDVIfhoGnwPbnOb1D8P
X3KgbAqhIBilFcTqA7fvul+F6TNNcYKnL2spKe5JV45iHXWdF1nsWSVugKUL/w0q
Bo61FGy/W5GrDJ4MwS05MLWLXADW3eH6q7nWI0gnBZYOxH0sPomduWcUwJs6KlMx
43harmNqrdHMo8Gj2Wb36hPuEH2o2kfXERmhKV8Egvx52+8LQZ38JoyCAbfbl/M=
=QAe4
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_13_05_50_+1000_U1BJD/rDZ6KB7uU8--
