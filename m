Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2IYQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:40:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43302 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab2IYQkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:40:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH 22/30] perf tools: bfd.h/libbfd detection fails with recent binutils
Date: Tue, 25 Sep 2012 12:40:30 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.2; KDE/4.6.5; x86_64; ; )
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <1348502384-14442-1-git-send-email-acme@infradead.org> <201209241958.33449.vapier@gentoo.org> <20120925064728.GA241@x4>
In-Reply-To: <20120925064728.GA241@x4>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2376834.odsvrsAiOf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201209251240.31854.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2376834.odsvrsAiOf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 25 September 2012 02:47:28 Markus Trippelsdorf wrote:
> On 2012.09.24 at 19:58 -0400, Mike Frysinger wrote:
> > On Monday 24 September 2012 11:59:36 Arnaldo Carvalho de Melo wrote:
> > > --- a/tools/perf/Makefile
> > > +++ b/tools/perf/Makefile
> > >=20
> > > -		FLAGS_BFD=3D$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
> > > +		FLAGS_BFD=3D$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -
DPACKAGE=3D'perf' -
> >=20
> > in this case, if you were to expand PACKAGE, you'd get back the symbol
> > perf (which most likely will be an error, but maybe it won't).  i think
> > this should
> >=20
> > be instead:
> > 	-DPACKAGE=3D'"perf"'
> > =09
> > > --- a/tools/perf/util/symbol.h
> > > +++ b/tools/perf/util/symbol.h
> > >=20
> > > +#define PACKAGE 'perf'
> >=20
> > this isn't valid C anywhere.  pretty sure this should be:
> > 	#define PACKAGE "perf"
>=20
> The only thing that's really important is that PACKAGE isn't NULL,

you mean "isn't defined".  i'm aware of that, but i'm trying to make you fu=
ture=20
proof in case PACKAGE gets expanded somewhere.

> So if you feel strongly about it, feel free to post a patch that just
> sets PACKAGE to 1. This would avoid all possible ambiguity.

no it wouldn't.  this define, in the context of binutils (and really any=20
autotools project), should be a string.  anything else is invalid.
=2Dmike

--nextPart2376834.odsvrsAiOf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQYd5/AAoJEEFjO5/oN/WBqOMP/39PUkYldYB0WdJnui4wM+xV
YXaWjBEx/taF7nZdjE4dRY110SM7ANItCcgvSqItNhI/GR82PmYHiCEdWf0NwKxZ
th9D5swtawvbowVrOVafZ8zfFSXLyXTqpMwRdbt/m/TcFnXFKzSv9a7GUw0gD8g1
oUTKedtjKuQgqC7g4QHBffbcXflyiE72tx7K009YynFei8I7fJv6WebuznR0OUnk
SPJ0PjwVZIIa5BJeuVy7XAsOYHdfVZ8V3oVOJ/wD6JKikda/gn8DtfYNfar7F41I
ax5Nr4USD+NCJLxOq3VoYXtuuFF9FcDK1lZZTTFy6TF4cjFKnsUcLcvhSHWnCEU0
wTptbywNWMRcAkR0KLXxq72MyhD70IwzZy83GQmrVr/MoMrOX3+pcJ+IsTxlTV3D
TCZXIeRSgwprM1BxLUWM4p4TpaDpsFfeUbuJCSX3TdSC9K2puxNwrupZ2n3yeBC5
pf90TWBV2l/d9XUH38SEvk9Uivm7r3JNNtwpGDMnMj15xp11nXfmFH81ZPETHLXe
tT0230f7U6ILTM3+NWA7ojo7ZQJsz6R45uhwLGmtQdmXs60JfZAebkZkv90FGN4W
Vj8wGpfjLMC92voH9JaEOkf5H8V0NH/4WptbEjLNRc2hC8QwJSCGcW922werp/x2
rZCEJZhiMAC2DIrGk5FL
=qgcJ
-----END PGP SIGNATURE-----

--nextPart2376834.odsvrsAiOf--
