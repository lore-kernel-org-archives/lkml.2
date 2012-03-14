Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480Ab2CNCZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:25:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759917Ab2CNCZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:25:30 -0400
Date: Wed, 14 Mar 2012 13:25:22 +1100
From: NeilBrown <neilb@suse.de>
To: Shaohua Li <shli@fusionio.com>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, <linux-kernel@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Message-ID: <20120314132522.4e1107a4@notabene.brown>
In-Reply-To: <4F5EA8E9.5010502@fusionio.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EA8E9.5010502@fusionio.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P/JjT4W4/q5v0Cz/=eWOBX9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/P/JjT4W4/q5v0Cz/=eWOBX9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Mar 2012 09:54:49 +0800 Shaohua Li <shli@fusionio.com> wrote:

> On 3/13/12 2:22 AM, Holger Kiehl wrote:
> >  Hello,
> >
> >  On Mon, 12 Mar 2012, Shaohua Li wrote:
> >
> > > The patches add TRIM support for raid linear/0/1/10. I'll add TRIM=20
> support for
> > > raid 4/5/6 later. The implementation is pretty straightforward and
> > > self-explained.
> > >
> >  First, thanks for this patch!
> >
> >  I have applied those patches against 3.3.0-rc7 and during boot the ker=
nel
> >  reports a lot of the following:
> >
> >  Mar 12 18:56:00 c3po kernel: [ 7.611045] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18861064 512
> >  Mar 12 18:56:00 c3po kernel: [ 7.611047] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18862088 512
> >  Mar 12 18:56:00 c3po kernel: [ 7.611049] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18863112 512
> >  Mar 12 18:56:00 c3po kernel: [ 7.611052] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18864136 512
> >  Mar 12 18:56:00 c3po kernel: [ 7.611054] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18865160 512
> >  Mar 12 18:56:00 c3po kernel: [ 7.611056] md/raid0:md3: make_request=20
> bug: can't convert block across chunks or bigger than 512k 18866184 512
> Thanks for testing. Looks I fixed a sanity check in bio.c but there are
> similar check in raid0/10 which I forgot to fix. Below patch should fix i=
t.
> please try.
>=20
>=20
> Subject: md: fix sanity check
>=20
> discard bio hasn't data attached and such bio can be split, don't consider
> this is illegial.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>   drivers/md/raid0.c  |    2 +-
>   drivers/md/raid10.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> Index: linux/drivers/md/raid0.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid0.c    2012-03-13 09:37:58.759976786 +0800
> +++ linux/drivers/md/raid0.c    2012-03-13 09:42:35.389975584 +0800
> @@ -496,7 +496,7 @@ static void raid0_make_request(struct md
>           sector_t sector =3D bio->bi_sector;
>           struct bio_pair *bp;
>           /* Sanity check -- queue functions should prevent this=20
> happening */
> -        if (bio->bi_vcnt !=3D 1 ||
> +        if ((bio->bi_vcnt !=3D 1 && bio->bi_vcnt !=3D0) ||

oh .. and there is the fix I mentioned that you would need :-)
Thanks,
NeilBrown



--Sig_/P/JjT4W4/q5v0Cz/=eWOBX9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2ABkjnsnt1WYoG5AQI0vA//dQbXACHnY6d2k9ErY5c93UFZQXOmZVIk
C7Op+GjHn/hIfQQsNYfcqcVGSgiws+/mdSmxchw0laf7rRDQt7UEWbZ3CGjJBBcS
Y3QXi188UNpJkdptaySfl+0cptqDZ7SrUKNSi1sZqowVXoMPFJlWDzrzwh4KaMTw
4cJHS+qnGfg/N9Kdt4zPwBpMzHLRTy1gMc1rvkbfwm/UO0hRIDCXWILiDs05GaEC
73bfGaLCL83f6mKRUg82n02H5B+Q67eTuYRiVdbIXYngV7gIWCfvLQugOK+UF1Ja
3ogEqokL73vNT69on1E15XBMuh30P5J6NA9MhqjR9ZmS4dc1+MwsZmqjt4emjhKD
lNGqIUMPDnJU8q20S3CPLkTVXtUsaMabsmVAkWdMYZbF97mzHK1pAkbE4ZxL14Ky
8hyCWmcuGpCrTLZiyPEru5Or0Qb+b6UpcY8+60BasBds0oxClOV0esTME66GhjvW
u4NqHuvKp6y8+3iuQVGlKtIAbp/O6fMiRlbmYL+fOnQwY/TavCkGLoJCpY2Q/dsM
v61ccIGrDqDCUzIUBCwOCzFtKL9X4qfNlfaPJoilUenQ0/zONds52V7BLjPhl2oD
csvXQecsKjO9aZkwNvJoQUTGznM6NG18vTPMLPatQnNE66RriIcAu4HQmh3UhbWt
6Gedp7h08fI=
=fBFx
-----END PGP SIGNATURE-----

--Sig_/P/JjT4W4/q5v0Cz/=eWOBX9--
